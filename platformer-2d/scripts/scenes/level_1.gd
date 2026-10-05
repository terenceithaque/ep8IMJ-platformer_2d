extends Node2D

# Position d'apparition du joueur
var SPAWN_POSITION = Vector2(0.0, 508.0)

# Obtenir les dimensions de la fenetre de jeu
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")


func _process(delta: float) -> void:
	if $player.is_out_of_screen():
		print("Le joueur est sorti de l'écran")
		$player.position.x = -451.0
		$player.position.y = 0.0
