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
		
	
	# Si le joueur a atteint la fin du niveau, passer au niveau suivant
	if $level_ending_panel.reached:
		save_script.save_player($player.serialize_data())
		get_tree().change_scene_to_file("res://scenes/main.tscn")
