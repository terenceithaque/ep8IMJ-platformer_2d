extends CharacterBody2D


var WALK_SPEED = 300.0
var RUN_SPEED = WALK_SPEED * 1.75
var SPEED = WALK_SPEED
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Obtenir les dimensions de la fenetre de jeu
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")


var JUMP_VELOCITY = -6000
var running = false

var direction = 0.0

func _ready() -> void:
	print("Largeur de la fenetre de jeu : ", screen_width)
	print("Hauteur de la fenetre de jeu : ", screen_height)
	

func is_out_of_screen() -> bool:
	if abs(position.x) > screen_width / 2:
		return true
	
	elif abs(position.y) > screen_height / 2:
		return true
	
	else:
		return false		


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
	
	if running:
		$sprite.play("run")
	
	# Obtenir la direction du joueur
	direction = Input.get_axis("gauche", "droite")
	#print(direction)
	
	if absi(direction) == 1:
		print(position)
		if not running:
			$sprite.play("walk")
			
		else:
			$sprite.play("run")	
		
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
		
	
	# Vérifier si le joueur est en train de courir
	if Input.is_action_pressed("courrir") and absi(direction) == 1:
		SPEED = RUN_SPEED
		running = true
	
	elif running and not Input.is_action_pressed("courrir"):
		SPEED = WALK_SPEED
		running = false		
	
			
	
			
			
			
	
	
	
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
