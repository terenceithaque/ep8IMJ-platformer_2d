extends CharacterBody2D


const SPEED = 300.0
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


func serialize_data() -> Dictionary: ## Regroupe les données du squelette dans un dictionnaire utilisable pour une sauvegarde
	var data = {
		"life": life,
		"max_life": max_life,
		"position": $sprite.position
	}
	return data


func fall(delta:float) -> void: ## Fait chuter le squelette selon la gravité
	
	velocity.y += gravity * delta

func is_out_of_window() -> bool: ## Renvoie true si le squelette est sorti de l'écran, false sinon
	if position.x > screen_width or position.x < -screen_width:
		return true
	
	elif position.y > screen_height or position.y < -screen_height:
		return true
		
	return false

"""func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta"""

	


func _on_change_direction_timer_timeout() -> void:
	$sprite.flip_h = true
