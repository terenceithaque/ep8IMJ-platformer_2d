extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	


func _on_play_button_pressed() -> void:
	# Lancer le premier niveau
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	
	



	


func _on_quit_button_pressed() -> void:
	# Quitter le jeu
	get_tree().quit()
