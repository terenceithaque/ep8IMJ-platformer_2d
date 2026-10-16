extends Node2D


func _ready() -> void:
	$music.play()
	

func _process(delta:float) -> void:
	
	var platform_3_area = get_node("canvas/platform_3_collision/platform_3_area")
	
	if $skeleton.is_on_floor():
		pass
		#print("Le squelette touche le sol")
	
	else:
		print("Le squelette ne touche pas le sol")
