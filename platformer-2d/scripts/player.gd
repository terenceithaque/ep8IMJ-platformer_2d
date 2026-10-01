extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	
	# Obtenir la direction du joueur
	var direction = Input.get_axis("gauche", "droite")
	
	if direction < 0:
		print("Déplacement vers la gauche")
	
	elif direction > 0:
		print("Déplacement vers la droite")
		
	
	if Input.is_action_just_pressed("saut"):
		print("Saut")			
