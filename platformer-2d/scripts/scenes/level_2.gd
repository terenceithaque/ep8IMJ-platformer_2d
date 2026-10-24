extends Node2D

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
@onready var initial_player_position = $player.position


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


	
	

func _process(delta:float) -> void:
	
	
	if $player.is_out_of_screen():
		#print("Le joueur est sorti de l'écran")
		$player.position =  $player.latest_ground_position
		$player.dammage(1)
	
	
	# Désactiver le squelette s'il sort de la fenetre
	
	if has_node("skeleton"):
		if $skeleton.is_out_of_window():
			#$skeleton.set_process(false)
			$skeleton.queue_free()
			#print("Le squelette est sorti de l'écran et a été désactivé")
		
		
		if $skeleton.is_player_colliding() and $skeleton.attacking:
			$player.dammage(1)
		
		if $skeleton.is_player_colliding() and $player.attacking:
			$skeleton.dammage($player.attack_dammage)
		
		# Vérifier si le joueur récupère une pièce
		if $player.get_collision() == "coin":
			print("Le joueur entre en collision avec une pièce")
			$player.increase_coin(5)
		
	if $level_ending_panel.reached:
		print("Le joueur a atteint la fin du niveau")
