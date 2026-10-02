extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	
	# Obtenir la direction du joueur
	var direction = Input.get_axis("gauche", "droite")
	
	if direction < 0:
		$sprite.flip_h = true
		$sprite.play("walk")
	
	elif direction > 0:
		$sprite.flip_h = false
		$sprite.play("walk")
	
	else:
		$sprite.stop()
		$sprite.play("idle")
		
	
	if Input.is_action_pressed("saut"):
		print("Saut")
		$sprite.play("jump")
					
