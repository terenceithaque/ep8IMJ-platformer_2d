extends Node2D
@onready var SAVE = preload("res://scripts/save.gd")

@onready var save_script = SAVE.new()


var resume_button_clicked = false



func _on_quit_button_pressed() -> void:
	save_script.save_player(get_parent().serialize_data())
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_resume_button_pressed() -> void:
	resume_button_clicked = true
