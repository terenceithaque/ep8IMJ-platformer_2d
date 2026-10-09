extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$music.play()
	$title.add_theme_font_override("font", load("res://assets/fonts/Isometra-Regular.ttf"))
	$PlayButton.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	


func _on_play_button_pressed() -> void:
	# Lancer le premier niveau
	
	#get_tree().change_scene_to_file("res://scenes/intro.tscn")
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	
	



	


func _on_quit_button_pressed() -> void:
	# Quitter le jeu
	get_tree().quit()


func _on_name_text_changed(new_text: String) -> void: ## Active ou désactive le bouton de jeu
	if len($name.text) == 0:
		$PlayButton.disabled = true
	
	else:
		$PlayButton.disabled = false	
	
