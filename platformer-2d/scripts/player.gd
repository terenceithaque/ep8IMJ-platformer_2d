extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -2000.0
var direction = 0.0


# Fonction pour faire sauter le personnage
func jump() -> void:
	
	
	print("Sur le sol")
	velocity.y += JUMP_VELOCITY
	$sprite.play("jump")
	move_and_slide()


# Fonction qui fait tomber le joueur
func fall() -> void:
	
	while not is_on_floor():	
		velocity.y -= JUMP_VELOCITY
		move_and_slide()
	
	$jump_timer.stop()	
		


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
	
	
		
	
	# Le personnage ne peut sauter que s'il est au sol
	if is_on_floor():
		if Input.is_action_just_released("saut"):
			print("Saut")
			jump()
			$jump_timer.start()	
				
	
	# Déplacere le personnage
	move_and_slide()	


# Gère les autres actions du joueur
func _process(float) -> void:
	if Input.is_action_just_released("attaque"):
		print("Attaque")
		$sprite.play("attack")
		


func _on_jump_timer_timeout() -> void:
	fall()
