extends Node2D


@onready var coins = get_tree().get_nodes_in_group("coins") # Récupérer les pièces dans le niveau
@onready var enemies = get_tree().get_nodes_in_group("enemies") # Récupérer les ennemis dans le niveau
const SAVE = preload("res://scripts/save.gd")
@onready var save_script = SAVE.new()

func _ready() -> void:
	
	var player_camera = get_node("player/Camera2D")
	print("Position de la caméra du joueur :", player_camera.position)
	
	# Positionner la caméra du joueur
	player_camera.set_limits(-4000.0, -1500.0, 8000.0, 5000.0)
	
	$music.play()
	


func _process(delta:float) -> void:
	
	
	# N'effectuer les traitements que si le jeu n'est pas en pause
	if not $player.paused:
		
		# Si le joueur sort de l'écran, le replacer
		if $player.is_out_of_screen():
			$player.position = $player.latest_ground_position
			$player.dammage(1) # Enlever 1 point de vie
		
		
		# Gérer les pièces
		for coin in coins:
			
			if is_instance_valid(coin):
				if $player.get_collision() == coin.name:
					if not coin.collected:
						$player.increase_coin(5)
						coin.collect()
						print(get_tree().get_nodes_in_group("save"))
						coin.remove_from_group("coins")
		
		# Gérer les ennemis
		for enemy in enemies:
			
			# On ne traite l'ennemi que s'il n'a pas été libéré de la mémoire
			if is_instance_valid(enemy):
				if not enemy.is_processing():
					enemy.set_process(true)
				
				if enemy.is_player_close():
					print(enemy.name, " est à proximité du joueur")
				
				if enemy.is_player_colliding() and enemy.attacking:
					$player.dammage(1)
				
				if enemy.is_player_colliding() and $player.attacking:
					enemy.dammage($player.attack_dammage)
				
				"""if enemy.is_out_of_window():
					enemy.queue_free()"""
	
	
	else:
		
		# Mettre les ennemis en pause
		for enemy in enemies:
			
			if is_instance_valid(enemy):
				enemy.set_process(false)
	
	# Si le joueur a atteint la fin du niveau, passer au niveau suivant
	if $level_ending_panel.reached:
		save_script.save_player($player.serialize_data())
		get_tree().change_scene_to_file("res://scenes/main.tscn")
