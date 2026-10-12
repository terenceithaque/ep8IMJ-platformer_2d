extends Node2D

var reached = false

# Called when the node enters the scene tree for the first time.
func _on_body_entered(body):
	if body.name == "player":
		reached = true
