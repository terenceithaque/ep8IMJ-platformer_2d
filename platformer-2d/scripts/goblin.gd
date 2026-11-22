extends CharacterBody2D


var SPEED = 200.0
var RUN_SPEED = SPEED * 1.75

const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2i.RIGHT

var latest_ground_position = position

var loot_chances = 0.3 # Chances qu'une pomme apparaisse à la mort du goblin

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")

var running = false
var attacking = false
var falling = false
var void_detected = false
var void_detected_timeout = false
var nb_void_detections = 0

var dead = false

var max_life = 10.0
var life = 10.0
var invincible = false
@onready var life_bar = get_node("display/life_bar")

@onready var player = get_parent().get_node("player")

func _ready():
	$sprite.play("idle")
	$loot.visible = false


func serialize_data() -> Dictionary: ## Regroupe les données du goblin dans un dictionnaire utilisable pour une sauvegarde
	var data = {
		"life": life,
		"max_life": max_life,
		"position": $sprite.position
	}
	return data

func update_life_bar(): ## Met à jour la valeur de la barre de vie du squelette
	
	life_bar.value = (life / max_life) * 100

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

func loots() -> void: ## Tire le score de probabilité qu'une pomme apparaisse, et fait apparaître une pomme si ce score est favorable.
	var score = randf() # Tirer une valeur aléatoire entre 0 et 1
	print("Score de loot : ", score)
	#if score >= (1 - loot_chances):
		# Faire apparaître une pomme
		
	print("Visibilité du goblin : ", visible)
	$loot.global_position = latest_ground_position
	await move_loot()	
	#get_parent().add_child($loot)
	"""print("Loot : ", $loot)
	print("Position globale du loot : ", $loot.global_position)
	print("Position du loot : ", $loot.position)"""


func move_loot(): ## Re-parente le loot du goblin quand la frame physique suivante est terminée
	$loot.freeze = true
	
	$loot.reparent.call_deferred(get_parent(), true)
	
	print("Reparentage programmé")

func fall(delta:float) -> void: ## Fait chuter le goblin selon la gravité
	
	velocity.y += gravity * delta
	falling = true
	
	

func dammage(points:int) -> void: ## Réduit la vie du goblin d'autant de points qu'indiqué.
	if not invincible:
		life -= points
		
		if life <= 0:
			$death_sound.play()
			$sprite.play("death")
			dead = true
	
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
	latest_ground_position = position
	
	
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
		falling = false
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
			print("Le goblin n'est pas à proximité du joueur")
			running = false
			attacking = false
			move()
			$sprite.play("walk")
	
	if dead:
		attacking = false
		
	update_void_detection_position()
	update_life_bar()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if is_processing():
		if not is_on_floor():
			fall(delta)
		
		else:
			if not attacking and not dead:
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
	if attacking and not dead:
		$sprite.play("attack")
		invincible = false
		
	elif dead:
		loots()
		queue_free()
	
	else:
		$sprite.play("walk")


func _on_invincibility_timer_timeout() -> void:
	if invincible:
		invincible = false
	
	else:
		invincible = true
