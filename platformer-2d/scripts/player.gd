extends CharacterBody2D


const SPEED = 300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var JUMP_VELOCITY = -6000

var direction = 0.0


# Fonction pour faire sauter le personnage
func jump(delta : float) -> void:
	
	#$jump_timer.start()
	
	velocity.y = JUMP_VELOCITY
	$sprite.play("jump")
	move_and_slide()


# Fonction qui fait tomber le joueur
func fall(delta : float) -> void:
	#JUMP_VELOCITY_PER_FRAME = abs(JUMP_VELOCITY_PER_FRAME)
	$sprite.play("fall")
	
	velocity.y += gravity * delta
	move_and_slide()
	
	#$jump_timer.stop()
		


# Fonction qui gère les mouvements du joueur
func _physics_process(delta: float) -> void:
	
	# Obtenir la direction du joueur
	direction = Input.get_axis("gauche", "droite")
	
	if abs(direction) == 1:
		$sprite.play("walk")
		
	else:
		$sprite.stop()
		$sprite.play("idle")
		velocity = Vector2(0.0, 0.0)
		
		
	if direction < 0:
		$sprite.flip_h = true
		velocity = Vector2(direction, 0.0) * SPEED
		
	
	elif direction > 0:
		$sprite.flip_h = false
		velocity = Vector2(direction, 0.0) * SPEED
	
	
	
	# Déplacer le personnage
	move_and_slide()
	
	# Le personnage ne peut sauter que s'il est au sol
	if is_on_floor() and Input.is_action_just_released("saut"):
			print("Saut")
			jump(delta)
	
	elif not is_on_floor():
		fall(delta)		
	
				
	
		


# Gère les autres actions du joueur
func _process(float) -> void:
	if Input.is_action_just_released("attaque"):
		print("Attaque")
		$sprite.play("attack")
		


func _on_total_jump_timer_timeout() -> void:
	"""var max_jump_height = velocity.y - 2000
	
	if velocity.y > max_jump_height:
		jump()
	
	
	else:
		fall()"""
