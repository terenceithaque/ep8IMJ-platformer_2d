extends CharacterBody2D

var SPEED = 200.0
var RUN_SPEED = SPEED * 1.75
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2i.RIGHT

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")

var running = false
var attacking = false
var void_detected = false
var void_detected_timeout = false
var nb_void_detections = 0

var max_life = 2.0
var life = 2.0
var invincible = false

@onready var player = get_parent().get_node("player")
@onready var life_bar = get_node("display/life_bar")

func update_life_bar(): ## Met à jour la position de la barre de vie du squelette ainsi que sa valeur
	life_bar.position.x = position.x
	life_bar.position.y = position.y - 50
	life_bar.value = (life / max_life) * 100

func fall(delta:float) -> void: ## Fait chuter le squelette selon la gravité
	
	velocity.y += gravity * delta
	
	#print(velocity)
	

func is_out_of_window() -> bool: ## Renvoie true si le squelette est sorti de l'écran, false sinon
	if position.x > screen_width or position.x < -screen_width:
		return true
	
	elif position.y > screen_height or position.y < -screen_height:
		return true
		
	return false

func dammage(points:int) -> void: ## Réduit la vie du squelette d'autant de points qu'indiqué. Si le squelette est dans une frame d'invincibilité, rien ne se passe.
	if not invincible:
		life -= points
		
		# Détruire le noeud du squelette si sa vie restante tombe à 0 ou en-dessous
		if life <= 0:
			queue_free()
		
		invincible = true
		$invincibility_timer.start()
			


func is_player_close(): ## Renvoie true si le joueur est à proximité, false sinon
	var distance = abs(position.x - player.position.x)
	#print(distance)
	return distance <= 200

func is_player_colliding() -> bool: ## Renvoie True si le joueur est en collision avec le squelette
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var body := collision.get_collider()
		return body.name == "player"
	
	return false
	

func change_direction(): ## Change la direction vers laquelle le squelette se dirige
	print("Changement de direction")
	if direction.x == -1:
		direction = Vector2i.RIGHT
		$sprite.flip_h = false
	
	else:
		direction = Vector2i.LEFT
		$sprite.flip_h = true

func is_void_close(): ## Renvoie true si le vide est près du squelette, false sinon
	return not $void_detection.is_colliding()

func move(): ## Déplace le squelette selon sa direction actuelle
	if not running:
			if direction.x == -1:
				velocity = Vector2(direction.x, 0.0) * SPEED
			
			elif direction.x == 1:
				velocity = Vector2(direction.x, 0.0) * SPEED
		
	else:
		if direction.x == -1:
			velocity = Vector2(direction.x, 0.0) * RUN_SPEED
				
		elif direction.x == 1:
			velocity = Vector2(direction.x, 0.0) * RUN_SPEED

func update_void_detection_position(): ## Définit la position du noeud de détection du vide en fonction de la direction du squelette
	if direction == Vector2i.LEFT:
		$void_detection.target_position.x = $sprite.position.x - 20
		$void_detection.target_position.y = $sprite.position.y
	
	else:
		$void_detection.target_position.x = $sprite.position.x + 20
		$void_detection.target_position.y = $sprite.position.y


func _process(delta:float) -> void:	
	if not is_on_floor():
		fall(delta)
	
	else:
		
		if is_void_close() and void_detected_timeout:
			void_detected = true
			void_detected_timeout = false
			#print("Le squelette est près du vide")
			change_direction()
			#move()
			#$sprite.flip_h = true
			$change_direction_timer.start()
			#$void_detected.start()
			nb_void_detections += 1
		
		else:
			void_detected = false
		
		
			
			
			
		# Déplacements vers la gauche ou la droite
		
		
		
		
		if is_player_close():
			#print("Le squelette a repéré le joueur")
			
			attacking = true
			
			"""if not void_detected:
				if position.x - player.position.x < 0:
					direction = Vector2i.LEFT
					#$sprite.flip_h = true
					running = true
				
				elif position.x - player.position.x > 0:
					direction = Vector2i.RIGHT
					#$sprite.flip_h = true
					running = true
				
				# Désactiver le timer de changement de direction
				$change_direction_timer.stop()"""
		
		else:
			running = false
			attacking = false
			move()
			$sprite.play("walk")
	
	move_and_slide()
	update_void_detection_position()
	update_life_bar()



func _on_change_direction_timer_timeout() -> void:
	
	change_direction()
	#$sprite.flip_h = true
	
	#print(direction)


func _on_void_detected_timeout() -> void:
	print(void_detected_timeout)
	void_detected_timeout = true


func _on_sprite_animation_finished() -> void:
	print($sprite.animation)
	if attacking:
		$sprite.play("attack")
	
	else:
		$sprite.play("walk")


func _on_invincibility_timer_timeout() -> void:
	invincible = false
