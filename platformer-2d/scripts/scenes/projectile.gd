extends CharacterBody2D

var SPEED = 450.0 # Vitesse de déplacement du projectile en pixels
var direction = Vector2i.RIGHT

# Récupérer les limites gauche et droite de la caméra du joueur
var limit_left = Global.camera_limit_left
var limit_right = Global.camera_limit_right



func _ready():
	position = get_parent().position
	visible = true
	print("Limite gauche de la caméra (récupérée dans global) : ", limit_left)
	print("Limite droite de la caméra (récupérée dans global) : ", limit_right)


func is_out_of_window() -> bool: ## Renvoie true si le projectile est sorti de l'écran, false sinon
	#print("Position x du projectile à la sortie de l'écran : ", position.x)
	
	if position.x < limit_left or position.x > limit_right:
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
		queue_free() # Libérer le projectile
	
