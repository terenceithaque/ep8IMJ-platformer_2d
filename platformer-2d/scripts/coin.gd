extends StaticBody2D


var collected = false

func _ready():
	$sprite.play("turn")
	
	
		

func play_collected_sound():
	if collected:
		$collected.play()
		
		
		
func _on_collected_finished() -> void:
	
	queue_free()	


func _on_sprite_animation_finished() -> void:
	$sprite.play("turn")
