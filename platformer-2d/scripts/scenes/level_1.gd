extends Node2D

# Position d'apparition du joueur
var SPAWN_POSITION = Vector2(0.0, 508.0)

# Obtenir les dimensions de la fenetre de jeu
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
@onready var initial_player_position = $player.position

func _ready():
	var camera = get_node("player/Camera2D")
	camera.limit_left = -1100.0
	camera.limit_top = -1500.0
	camera.limit_right = 2000.0
	camera.limit_bottom = 1200.0



func _process(delta: float) -> void:
	
	# Vérifier si le joueur a atteint le panneau de fin de niveau
	
	#print("Objet entré en collision avec le joueur :", $player.get_collision())
	
	if $player.is_out_of_screen():
		print("Le joueur est sorti de l'écran")
		$player.position = initial_player_position
		$player.dammage(1)
	
	if $level_ending_panel.reached:
		get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")
