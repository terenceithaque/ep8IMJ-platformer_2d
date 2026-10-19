extends Node2D


func _ready() -> void:
	$death.play()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
