extends Node2D


func _ready() -> void:
	$music.play()
	

func _process(delta:float) -> void:
	
	if $skeleton.is_on_floor():
		print("Le squelette touche le sol")
	
	else:
		print("Le squelette ne touche pas le sol")
