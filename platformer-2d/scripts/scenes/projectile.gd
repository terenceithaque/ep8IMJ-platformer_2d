extends CharacterBody2D

var SPEED = 450.0 # Vitesse de déplacement du projectile en pixels
var direction = Vector2i.RIGHT

func _ready():
	position = get_parent().position
	visible = true

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
	
