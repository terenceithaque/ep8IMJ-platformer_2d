extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var animation = get_node("context_label/AnimationPlayer")
	$music.play()
	$context_label/AnimationPlayer.play("text_scroll")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
