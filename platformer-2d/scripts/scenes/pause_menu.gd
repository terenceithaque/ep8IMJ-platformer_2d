extends Node2D


var resume_button_clicked = false



func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_resume_button_pressed() -> void:
	resume_button_clicked = true
