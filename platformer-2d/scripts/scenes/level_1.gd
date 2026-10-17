extends Node2D

# Position d'apparition du joueur
var SPAWN_POSITION = Vector2(0.0, 508.0)

# Obtenir les dimensions de la fenetre de jeu
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
@onready var initial_player_position = $player.position



func _process(delta: float) -> void:
	
	# Vérifier si le joueur a atteint le panneau de fin de niveau
	
	#print("Objet entré en collision avec le joueur :", $player.get_collision())
	
	if $player.is_out_of_screen():
		print("Le joueur est sorti de l'écran")
		$player.position = $player.position
	
	if $level_ending_panel.reached:
		get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")
