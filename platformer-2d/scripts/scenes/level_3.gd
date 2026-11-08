extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var player_camera = get_node("player/Camera2D")
	print("Position de la caméra du joueur :", player_camera.position)
	
	player_camera.set_limits(-200.0, -1500.0, 4000.0, 4000.0)
