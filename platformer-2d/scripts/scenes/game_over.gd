extends Node2D
var SAVE = preload("res://scripts/save.gd")

@onready var save_script = SAVE.new()

func _ready() -> void:
	$death.play()




func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_replay_button_pressed() -> void:
	var save_data = save_script.open_player_save(Global.player_name)
	Global.player_save_state = save_data["mainchar"]
	Global.level_save_state = save_data["levels"]
	get_tree().change_scene_to_file(Global.player_save_state["level"])
