extends CharacterBody2D


var WALK_SPEED = 300.0
var RUN_SPEED = WALK_SPEED * 1.75
var SPEED = WALK_SPEED
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var max_life = 5.0 # Vie (coeurs) du joueur
var life = 5.0
@onready var life_bar = get_node("GUI/life_bar")

# Obtenir les dimensions de la fenetre de jeu
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")

var nb_hits = 0 # Nombre de coups subits par le joueur


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


func dammage(points:int): ## Réduit la vie du joueur du nombre de points indiqués et met à jour la barre de vie
	life -= points
	print(life)
	life_bar.value = (life / max_life) * 100
	nb_hits += 1
	
	if nb_hits == 1:
		$hit_1.play()
	
	elif nb_hits == 2:
		$hit_2.play()
	
	elif nb_hits == 3:
		$hit_3.play()
	
	elif nb_hits == 4:
		$hit_4.play()
	
	elif nb_hits == 5:
		$hit_5.play()
		nb_hits = 0
	


var JUMP_VELOCITY = -12000
var JUMP_VELOCITY_RUNNING = JUMP_VELOCITY * 1.5

var running = false
var looking_up = false
var looking_down = false
var attacking = false
var attack_number = 1


var tutorial_popup_scene = preload("res://scenes/tutorial_popup.tscn")

var tutorial_completion_flags = {
	"walk_tutorial_completed": false,
	"run_tutorial_completed": false,
	"jump_tutorial_completed": false,
	"attack_tutorial_completed": false
}

var direction = 0.0

func _ready() -> void:
	
	$sprite.play("idle")
	var move_left = get_key_name(move_left_keys)
	var move_right = get_key_name(move_right_keys)
	var jump_key_name = get_key_name(jump_key)
	var run_key_name = get_key_name(run_key)
	
	print(move_left)
	print(move_right)
	
	
	# 1ère popup de tutoriel
	display_tutorial("Déplacements de base",
		("Utilisez les touches {move_left} et {move_right}
		pour déplacer le samurai.".format({"move_left":move_left, "move_right":move_right})), "walk_tutorial_completed")
	
	print(get_tutorial_popups())
	

func display_tutorial(tutorial_title:String, tutorial_text:String, flag_name:String): ## Affiche une nouvelle popup de tutoriel à l'écran
	var popup = tutorial_popup_scene.instantiate()
	popup.set_popup_title(tutorial_title)
	popup.set_popup_text(tutorial_text)
	popup.set_completion_flag_name(flag_name)
	
	$Camera2D.add_child(popup)

func is_out_of_screen() -> bool:
	if position.x < $Camera2D.limit_left:
		print("Le joueur est sorti de l'écran par la gauche")
		return true
	
	elif position.x > $Camera2D.limit_right:
		print("Le joueur est sorti de l'écran par la droite")
		return true
	
	elif position.y < $Camera2D.limit_top:
		print("Le joueur est sorti de l'écran par le haut")
		return true
	
	elif position.y > $Camera2D.limit_bottom:
		print("Le joueur est sorti de l'écran par le bas")
		return true
	
	else:
		return false
		


func get_tutorial_popups(): ## Renvoie un tableau des popups de tutoriel attachées à la caméra du jeu
	var tutorials = []
	
	for element in $Camera2D.get_children():
		print(element.name)


func update_tutorial_completion_flags(completion_flag) -> void:
	var flag_name = completion_flag["name"]
	var flag_value = completion_flag["completed"]
	
	tutorial_completion_flags[flag_name] = flag_value
	
	print(tutorial_completion_flags)

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

func attack():
	if not attacking:
		attacking = true
		
		if attack_number == 1:
			$sprite.play("attack_1")
		
		elif attack_number == 2:
			$sprite.play("attack_2")
		
		elif attack_number == 3:
			$sprite.play("attack_3")
			attack_number = 1
		
		$attack_sound.play()
		attack_number += 1
	
	else:
		attacking = false

func get_collision(): ## Retourne le nom de l'objet avec lequel le joueur est entré en collision
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var body := collision.get_collider()
		return body.name # Renvoyer le nom de l'objet
	
	return ""


func is_animation_playing(): ## Renvoie true si une animation du joueur (autre que "idle") est active, sinon renvoie false
	print($sprite.animation)
	return $sprite.is_playing() and $sprite.animation != "idle"
	


# Fonction qui gère les mouvements du joueur
func _physics_process(delta: float) -> void:
	
	if running:
		if $sprite.animation != "run":
			$sprite.play("run")
	
	# Obtenir la direction du joueur
	direction = Input.get_axis("gauche", "droite")
	#print(direction)
	
	if absi(direction) == 1:
		if not running:
			
			if $sprite.animation != "walk":
				$sprite.play("walk")
			#$run_sound.stop()
			$walk_sound.play()
			
		else:
			$sprite.play("run")
			#$walk_sound.stop()
			$run_sound.play()
		
	else:
		#$sprite.stop()
		#$walk_sound.stop()
		#$run_sound.stop()
		
		
		#print("Animation en cours : ", is_animation_playing())
		
		if $sprite.animation == "walk" or $sprite.animation == "run":
			$sprite.play("idle")
		
	
		#$sprite.play("idle")
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
	
	# Afficher l'écran de game over si le joueur n'a plus de vies
	if life <= 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		
		
	if Input.is_action_just_released("attaque"):
		attack()
		
	
	
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


func _on_sprite_animation_finished() -> void:
	if "attack" in $sprite.animation:
		$sprite.play("idle")
	
	if $sprite.animation == "walk" or $sprite.animation == "run":
		$sprite.play("idle")
	
	elif $sprite.animation == "fall":
		$sprite.play("idle")


func _on_attack_animation_reset_timeout() -> void:
	attack_number = 1
	
