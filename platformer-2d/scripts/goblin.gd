extends CharacterBody2D


var SPEED = 200.0
var RUN_SPEED = SPEED * 1.75

const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2i.RIGHT

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")

var running = false
var attacking = false
var void_detected = false
var void_detected_timeout = false
var nb_void_detections = 0

var max_life = 5.0
var life = 5.0
var invincible = false

func _ready():
	$sprite.play("walk")


func serialize_data() -> Dictionary: ## Regroupe les données du goblin dans un dictionnaire utilisable pour une sauvegarde
	var data = {
		"life": life,
		"max_life": max_life,
		"position": $sprite.position
	}
	return data


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
	
	print("Direction du goblin : ", direction.x)
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
	
	
func is_out_of_window() -> bool: ## Renvoie true si le goblin est sorti de l'écran, false sinon
	if position.x > screen_width or position.x < -screen_width:
		return true
	
	elif position.y > screen_height or position.y < -screen_height:
		return true
		
	return false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	"""if not is_on_floor():
		fall(delta)"""
	
	move()
	
	move_and_slide()
	


func _on_change_direction_timer_timeout() -> void:
	change_direction()


func _on_walk_sound_timer_timeout() -> void:
	if not $walk_sound.playing:
		$walk_sound.play()
		
