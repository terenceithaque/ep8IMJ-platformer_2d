extends CharacterBody2D

var SPEED = 200.0
var RUN_SPEED = SPEED * 1.75
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2i.RIGHT

var running = false
var attacking = false

@onready var player = get_parent().get_node("player")

func fall(delta:float) -> void: ## Fait chuter le squelette selon la gravité
	
	velocity.y += gravity * delta
	
	#print(velocity)
	

func is_player_close(): ## Renvoie true si le joueur est à proximité, false sinon
	var distance = abs(position.x - player.position.x)
	print(distance)
	return distance <= 400


func _process(delta:float) -> void:
	
	
	if not is_on_floor():
		fall(delta)
	
	else:
		# Déplacements vers la gauche ou la droite
		if not running:
			if direction.x == -1:
				velocity = Vector2(direction.x, 0.0) * SPEED
			
			elif direction.x == 1:
				velocity = Vector2(direction.x, 0.0) * SPEED
		
		else:
			if not running:
				if direction.x == -1:
					velocity = Vector2(direction.x, 0.0) * RUN_SPEED
				
				elif direction.x == 1:
					velocity = Vector2(direction.x, 0.0) * RUN_SPEED
		
		
		$sprite.play("walk")
		
		if is_player_close():
			print("Le squelette a repéré le joueur")
			if position.x - player.position.x < 0:
				direction = Vector2i.LEFT
				$sprite.flip_h = true
				running = true
			
			elif position.x - player.position.x > 0:
				direction = Vector2i.RIGHT
				$sprite.flip_h = true
				running = true
			
			# Désactiver le timer de changement de direction
			$change_direction_timer.stop()
		
		else:
			running = false
	
	move_and_slide()


func _on_change_direction_timer_timeout() -> void:
	
	if direction == Vector2i.RIGHT:
		direction = Vector2i.LEFT
		$sprite.flip_h = true
	
	elif direction == Vector2i.LEFT:
		direction = Vector2i.RIGHT
		$sprite.flip_h = false
	
	print(direction)
