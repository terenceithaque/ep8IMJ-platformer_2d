extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$music.play()


func _on_music_finished() -> void:
	
	# Retourner au menu principal quand la musique s'achève
	get_tree().change_scene_to_file("res://scenes/main.tscn")
