extends CharacterBody2D


var SPEED = 200.0
var RUN_SPEED = SPEED * 1.75

const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2i.RIGHT

var loot = preload("res://scenes/apple.tscn") # Loot du goblin (quand tué par le joueur)

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")

var running = false
var attacking = false
var void_detected = false
var void_detected_timeout = false
var nb_void_detections = 0

var dead = false

var max_life = 5.0
var life = 5.0
var invincible = false

@onready var player = get_parent().get_node("player")

func _ready():
	$sprite.play("idle")


func serialize_data() -> Dictionary: ## Regroupe les données du goblin dans un dictionnaire utilisable pour une sauvegarde
	var data = {
		"life": life,
		"max_life": max_life,
		"position": $sprite.position
	}
	return data


func is_player_close(): ## Renvoie true si le joueur est à proximité, false sinon
	var distance = abs(position.x - player.position.x)
	
	#print(distance)
	return distance <= 1000

func is_player_colliding() -> bool: ## Renvoie True si le joueur est en collision avec le goblin
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var body := collision.get_collider()
		return body.name == "player"
	
	return false

func fall(delta:float) -> void: ## Fait chuter le goblin selon la gravité
	
	velocity.y += gravity * delta

func change_direction(): ## Change la direction vers laquelle le goblin se dirige
	print("Changement de direction")
	if direction.x == -1:
		direction = Vector2i.RIGHT
		$sprite.flip_h = false
	
	else:
		direction = Vector2i.LEFT
		$sprite.flip_h = true


func update_void_detection_position(): ## Définit la position du noeud de détection du vide en fonction de la direction du goblin
	if direction == Vector2i.LEFT:
		$void_detection.target_position.x = $sprite.position.x - 20
		$void_detection.target_position.y = $sprite.position.y
	
	else:
		$void_detection.target_position.x = $sprite.position.x + 20
		$void_detection.target_position.y = $sprite.position.y

func move(): ## Déplace le goblin selon sa direction actuelle
	
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
	
	$sprite.play("walk")
	
	
func is_out_of_window() -> bool: ## Renvoie true si le goblin est sorti de l'écran, false sinon
	if position.x > screen_width or position.x < -screen_width:
		return true
	
	elif position.y > screen_height or position.y < -screen_height:
		return true
		
	return false


func is_void_close(): ## Renvoie true si le vide est près du squelette, false sinon
	return not $void_detection.is_colliding()

func _process(delta: float) -> void:
	
	print("Animation du goblin : ", $sprite.animation)
	if not is_on_floor():
		fall(delta)
	
	else:
		
		if not dead:
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
		
		
			
			
					
		if is_player_close():
			#print("Le squelette a repéré le joueur")
			
			if not dead:
				attacking = true
				print("Le goblin passe à l'attaque")
			

		
		else:
			running = false
			attacking = false
			move()
			$sprite.play("walk")
	
	update_void_detection_position()
	#update_life_bar()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if is_processing():
		if not is_on_floor():
			fall(delta)
		
		else:
			if not attacking:
				move()
			
		move_and_slide()
	
	else:
		$sprite.stop()
	


func _on_change_direction_timer_timeout() -> void:
	
	if is_processing() and not attacking:
		change_direction()


func _on_walk_sound_timer_timeout() -> void:
	if not $walk_sound.playing:
		$walk_sound.play()




func _on_sprite_animation_finished() -> void:
	print($sprite.animation)
	

	print("attacking : ", attacking)
	if attacking:
		$sprite.play("attack")
		
	elif dead:
		$sprite.play("death")
		queue_free()
	
	else:
		$sprite.play("walk")
