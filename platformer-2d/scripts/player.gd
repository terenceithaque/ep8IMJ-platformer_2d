extends CharacterBody2D


var WALK_SPEED = 300.0
var RUN_SPEED = WALK_SPEED * 1.75
var SPEED = WALK_SPEED
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var max_life = 5 # Vie (coeurs) du joueur
var life = 5

# Obtenir les dimensions de la fenetre de jeu
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")


# Récupérer les touches utilisées pour les différentes actions du joueur
var move_right_keys = ProjectSettings.get_setting("input/droite")
var move_left_keys = ProjectSettings.get_setting("input/gauche")
var jump_key = ProjectSettings.get_setting("input/saut")
var run_key = ProjectSettings.get_setting("input/courrir")

var camera_up_key = ProjectSettings.get_setting("input/regarder_haut")
var camera_down_key = ProjectSettings.get_setting("input/regarder_bas")


var attack_key = ProjectSettings.get_setting("input/attaque")


var action_keys = [move_right_keys, move_left_keys, jump_key, run_key, camera_up_key,
				   camera_down_key, attack_key]


func get_key_name(key: Variant) -> String: ## Renvoie le nom de la touche d'action donnée en paramètre.
	
	# input_event_key est un objet de type Array (tableau)
	var input_event_key = key["events"]
		
	# Le nom de la touche est compris dans le key code
	var key_code = str(input_event_key[0]).split(",")[0]
	var key_name = key_code.split(" ")[2]
	
	key_name = key_name.remove_chars("()")
	return key_name




var JUMP_VELOCITY = -12000
var JUMP_VELOCITY_RUNNING = JUMP_VELOCITY * 1.5

var running = false
var looking_up = false
var looking_down = false

var direction = 0.0

func _ready() -> void:
	var first_tutorial_popup = get_node("Camera2D/tutorial_popup_1")
	var tutorial_label = first_tutorial_popup.get_child(0)
	var move_left = get_key_name(move_left_keys)
	var move_right = get_key_name(move_right_keys)
	print(move_left)
	print(move_right)
	tutorial_label.text = "Utilisez les touches {move_left} et {move_right} pour déplacer
	le samurai".format({"move_left":move_left, "move_right":move_right})
	
	$GUI/life_bar.update(life, max_life)
	

func is_out_of_screen() -> bool:
	if abs(position.x) > screen_width:
		return true
	
	elif abs(position.y) > screen_height:
		return true
	
	else:
		return false		


# Fonction pour faire sauter le personnage
func jump(delta : float) -> void:
	
	#$jump_timer.start()
	
	if running:
		velocity.y = JUMP_VELOCITY_RUNNING
	else:
		velocity.y = JUMP_VELOCITY
	
	$sprite.play("jump")
	$jump_sound.play()
	move_and_slide()


# Fonction qui fait tomber le joueur
func fall(delta : float) -> void:
	#JUMP_VELOCITY_PER_FRAME = abs(JUMP_VELOCITY_PER_FRAME)
	$sprite.play("fall")
	
	velocity.y += gravity * delta
	move_and_slide()
	
	
	
	#$jump_timer.stop()
	
	
func look_up() -> void:
	
	looking_down = false
	if not looking_up:
		$Camera2D.position.y -= 100
		looking_up = true

func look_down() -> void:
	looking_up = false
	if not looking_down:
		$Camera2D.position.y += 100
		looking_down = true


func get_collision(): ## Retourne le nom de l'objet avec lequel le joueur est entré en collision
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var body := collision.get_collider()
		return body.name # Renvoyer le nom de l'objet
	
	return ""
	


# Fonction qui gère les mouvements du joueur
func _physics_process(delta: float) -> void:
	
	if running:
		$sprite.play("run")
	
	# Obtenir la direction du joueur
	direction = Input.get_axis("gauche", "droite")
	#print(direction)
	
	if absi(direction) == 1:
		if not running:
			$sprite.play("walk")
			#$run_sound.stop()
			$walk_sound.play()
			
		else:
			$sprite.play("run")
			#$walk_sound.stop()
			$run_sound.play()
		
	else:
		$sprite.stop()
		#$walk_sound.stop()
		#$run_sound.stop()
		
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
	
	#$Camera2D.position = position
	
			
	
			
			
			
	
	
	
	# Déplacer le personnage
	move_and_slide()
	
	# Le personnage ne peut sauter que s'il est au sol
	if is_on_floor() and Input.is_action_pressed("saut"):
			print("Saut")
			jump(delta)
	
	elif not is_on_floor():
		fall(delta)
		$Camera2D.align()			
	
				
	
		


# Gère les autres actions du joueur
func _process(float) -> void:
	if Input.is_action_just_released("attaque"):
		print("Attaque")
		$sprite.play("attack")
		$attack_sound.play()
	
	if Input.is_action_pressed("regarder_haut", true):
		look_up()
	
	elif Input.is_action_pressed("regarder_bas", true):
		look_down()
	
	else:
		$Camera2D.align()
		looking_up = false
		looking_down = false
		


func _on_total_jump_timer_timeout() -> void:
	"""var max_jump_height = velocity.y - 2000
	
	if velocity.y > max_jump_height:
		jump()
	
	
	else:
		fall()"""
