extends StaticBody2D


var collected = false

func _process(delta: float) -> void:
	$sprite.play("turn")
	
	
		

func play_collected_sound():
	if collected:
		$collected.play()

func _on_collected_finished() -> void:
	queue_free()
