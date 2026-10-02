extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction = 0.0


# Fonction pour faire sauter le personnage
func jump() -> void:
	
	# Le personnage ne peut sauter que s'il est au sol
	if is_on_floor():
		print("Sur le sol")
		velocity.y += JUMP_VELOCITY
		$sprite.play("jump")
		move_and_slide()
		
	else:
		print("Pas sur le sol")	
		


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
	
	
		
	
	if Input.is_action_pressed("saut"):
		print("Saut")
		jump()
		
	
	# Déplacere le personnage
	move_and_slide()	


# Gère les autres actions du joueur
func _process(float) -> void:
	if Input.is_action_just_released("attaque"):
		print("Attaque")
		$sprite.play("attack")
		
