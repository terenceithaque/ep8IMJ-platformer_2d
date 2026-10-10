extends Node2D


# Called when the node enters the scene tree for the first time.
func _on_body_entered(body):
	if body.name == "player":
		print("Le joueur a atteint la fin du niveau !")
