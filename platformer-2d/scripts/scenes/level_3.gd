extends Node2D


@onready var coins = get_tree().get_nodes_in_group("coins") # Récupérer les pièces dans le niveau
@onready var food = get_tree().get_nodes_in_group("food")
@onready var enemies = get_tree().get_nodes_in_group("enemies") # Récupérer les ennemis dans le niveau
const SAVE = preload("res://scripts/save.gd")
@onready var save_script = SAVE.new()

func _ready() -> void:
	
	var player_camera = get_node("player/Camera2D")
	print("Position de la caméra du joueur :", player_camera.position)
	
	# Positionner la caméra du joueur
	player_camera.set_limits(-4000.0, -1500.0, 8000.0, 5000.0)
	
	$music.play()
	
	# Définir les exceptions de collision
	for enemy in enemies:
		for coin in coins:
			enemy.add_collision_exception_with(coin)
				
		
		for enemy2 in enemies:
			enemy.add_collision_exception_with(enemy2)


func _process(delta:float) -> void:
	
	
	food = get_tree().get_nodes_in_group("food")
	print("Food : ", food)
	print("Ennemis : ", enemies)
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
		
		# Gérer la nourriture
		for feeding in food:
			
			if is_instance_valid(feeding):
				print("Position de la nourriture : ", feeding.position)
				print("Masque de collision de la nourriture : ", feeding.collision_mask)
				print("Couche de collision de la nourriture : ", feeding.collision_layer)
				
				if $player.get_collision() == feeding.name:
					feeding.play_bite_sound()
					feeding.dissapear()
					$player.increase_life(2)
					feeding.remove_from_group("food")
		
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
				
				"""if enemy.is_out_of_window() and enemy.falling:
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


func _on_child_entered_tree(node: Node) -> void:
	
	if "loot" in node.name:
		node.visible = true
		node.add_to_group("food")
		print("Food : ", food)
