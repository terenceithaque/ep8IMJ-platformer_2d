extends CharacterBody2D

var direction = Vector2i.RIGHT


func _process(delta:float) -> void:
	
		
		
	$sprite.play("walk")


func _on_change_direction_timer_timeout() -> void:

	if direction == Vector2i.RIGHT:
		direction = Vector2i.LEFT
		$sprite.flip_h = true
	
	elif direction == Vector2i.LEFT:
		direction = Vector2i.RIGHT
		$sprite.flip_h = false
