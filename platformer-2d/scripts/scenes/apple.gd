extends RigidBody2D

var consumed = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func play_bite_sound():
	$sound.play()


func dissapear() -> void: ## Cache le sprite de la pomme et désactive sa boîte de collision
	$sprite.visible = false
	$collision_shape.disabled = true
