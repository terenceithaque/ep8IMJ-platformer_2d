extends Node2D

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
@onready var initial_player_position = $player.position


func _ready() -> void:
	$music.play()
	"""var background_image = get_node("canvas/background_image")
	var background_image_scale = screen_width / background_image.texture.get_size().x"""
	
	var camera = get_node("player/Camera2D")
	camera.limit_left = -400.0
	camera.limit_top = -1500.0
	camera.limit_right = 1500.0
	camera.limit_bottom = 1200.0
	
	#background_image.set_scale(Vector2(background_image_scale, background_image_scale))


	
	

func _process(delta:float) -> void:
	
	
	if $player.is_out_of_screen():
		#print("Le joueur est sorti de l'écran")
		$player.position = initial_player_position
	
	
	# Désactiver le squelette s'il sort de la fen
	if $skeleton.is_out_of_window():
		$skeleton.set_process(false)
		print("Le squelette est sorti de l'écran et a été désactivé")
