extends Node2D


func _ready() -> void:
	$music.play()
	

func _process(delta:float) -> void:
	
	"""if $player.is_out_of_screen():
		$player.position.x = - 80.0
		$player.position.y = 635.0"""
	
	
	
	if $skeleton.is_on_floor():
		pass
		#print("Le squelette touche le sol")
	
	else:
		pass
