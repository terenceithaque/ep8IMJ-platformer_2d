extends Node2D

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
@onready var initial_player_position = $player.position


func _ready() -> void:
	$music.play()
	"""var background_image = get_node("canvas/background_image")
	var background_image_scale = screen_width / background_image.texture.get_size().x"""	
	
	#background_image.set_scale(Vector2(background_image_scale, background_image_scale))

func _process(delta:float) -> void:
	
	if $player.is_out_of_screen():
		#print("Le joueur est sorti de l'écran")
		$player.position = initial_player_position
	
	
	
	if $skeleton.is_on_floor():
		pass
		#print("Le squelette touche le sol")
	
	else:
		pass
