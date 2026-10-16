extends CharacterBody2D

var SPEED = 200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2i.RIGHT

var running = false
var attacking = false

func fall(delta:float) -> void: ## Fait chuter le squelette selon la gravité
	
	velocity.y += gravity * delta
	
	#print(velocity)


func _process(delta:float) -> void:
	
	
	if not is_on_floor():
		fall(delta)
	
	else:
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
