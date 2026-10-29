extends Node2D

const SAVE = preload("res://scripts/save.gd")
@onready var save_script = SAVE.new()

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
@onready var initial_player_position = $player.position
@onready var coins = get_tree().get_nodes_in_group("coins")

func _ready() -> void:
	$music.play()
	"""var background_image = get_node("canvas/background_image")
	var background_image_scale = screen_width / background_image.texture.get_size().x"""
	
	var camera = get_node("player/Camera2D")
	camera.limit_left = -400.0
	camera.limit_top = -1500.0
	camera.limit_right = 1500.0
	camera.limit_bottom = 1200.0
	
	#background_image.set_scale(Vector2(background_image_scale, background_image_scale))
	
	for coin in coins:
		$skeleton.add_collision_exception_with(coin)

	
	

func _process(delta:float) -> void:
	
	coins = get_tree().get_nodes_in_group("coins")
	
	if $player.is_out_of_screen():
		#print("Le joueur est sorti de l'écran")
		$player.position =  $player.latest_ground_position
		$player.dammage(1)
	
	
	
	
	# Ne mettre à jour l'état du niveau que si le jeu n'est pas en pause
	if not $player.paused:
		if has_node("skeleton"):
			# Désactiver le squelette s'il sort de la fenetre
			if $skeleton.is_out_of_window():
				#$skeleton.set_process(false)
				$skeleton.queue_free()
				#print("Le squelette est sorti de l'écran et a été désactivé")
			
			
			if $skeleton.is_player_colliding() and $skeleton.attacking:
				$player.dammage(1)
			
			if $skeleton.is_player_colliding() and $player.attacking:
				$skeleton.dammage($player.attack_dammage)
			
		# Vérifier si le joueur récupère une pièce
		
		for coin in coins:
			if $player.get_collision() == coin.name:
				
				if not coin.collected:
					$player.increase_coin(5)
					coin.collected = true
					coin.dissapear()
					coin.play_collected_sound()
					coin.remove_from_group("coins")
			
		if $level_ending_panel.reached:
			save_script.save_player($player.serialize_data())
			print("Le joueur a atteint la fin du niveau")
		
	else:
		$skeleton.set_process(false)
		
		for coin in coins:
			coin.set_process(false)
