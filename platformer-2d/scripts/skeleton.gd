extends CharacterBody2D

var SPEED = 200.0
var direction = Vector2i.RIGHT

var running = false
var attacking = false


func _process(delta:float) -> void:
	
	# Déplacements vers la gauche ou la droite
	if direction.x == -1:
		velocity = Vector2(direction.x, 0.0) * SPEED
	
	elif direction.x == 1:
		velocity = Vector2(direction.x, 0.0) * SPEED
	
	
	$sprite.play("walk")
	move_and_slide()


func _on_change_direction_timer_timeout() -> void:
	
	if direction == Vector2i.RIGHT:
		direction = Vector2i.LEFT
		$sprite.flip_h = true
	
	elif direction == Vector2i.LEFT:
		direction = Vector2i.RIGHT
		$sprite.flip_h = false
	
	print(direction)
