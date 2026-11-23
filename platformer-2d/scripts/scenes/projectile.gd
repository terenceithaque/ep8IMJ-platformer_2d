extends CharacterBody2D

var SPEED = 450.0 # Vitesse de déplacement du projectile en pixels
var direction = Vector2i.RIGHT

# Récupérer la largeur de l'écran
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

func _ready():
	position = get_parent().position
	visible = true


func is_out_of_window() -> bool: ## Renvoie true si le projectile est sorti de l'écran, false sinon
	if position.x > screen_width or position.x < (-screen_width):
		return true
	
	return false

func set_direction(dir:String="right") -> void: ## Définit la direction vers laquelle le projectile se déplace.
	if dir == "right":
		direction = Vector2i.RIGHT
	
	elif dir == "left":
		direction = Vector2i.LEFT
		

func move() -> void: ## Déplace le projectile selon sa direction actuelle
	velocity = Vector2(direction.x, 0.0) * SPEED


func _process(delta:float) -> void:
	move()
	move_and_slide()
	
	# Vérifier si le projectile sort de l'écran
	if is_out_of_window():
		print("Le projectile est sorti de l'écran")
	
