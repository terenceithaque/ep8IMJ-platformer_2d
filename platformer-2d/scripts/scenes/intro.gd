extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var animation = get_node("context_label/AnimationPlayer")
	$music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
