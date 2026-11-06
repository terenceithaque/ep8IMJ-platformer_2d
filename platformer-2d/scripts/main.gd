extends Node

const SAVE = preload("res://scripts/save.gd")

@onready var save_script = SAVE.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$music.play()
	$title.add_theme_font_override("font", load("res://assets/fonts/Isometra-Regular.ttf"))
	$PlayButton.disabled = true
	
	
	save_script.create_saves_dir()
	

func _on_play_button_pressed() -> void:
	# Lancer le premier niveau
	
	#get_tree().change_scene_to_file("res://scenes/intro.tscn")
	
	Global.set_player_name($name.text)
	print("Nom du joueur après défintion :", Global.player_name)
	if not $name.text in Global.saved_players:
		save_script.create_player_save($name.text)
		get_tree().change_scene_to_file("res://scenes/intro.tscn")
	
	else:
		var save_data = save_script.open_player_save($name.text)
		Global.player_save_state = save_data["mainchar"]
		Global.level_save_state = save_data["levels"]
		get_tree().change_scene_to_file(Global.player_save_state["level"])
	



	


func _on_quit_button_pressed() -> void:
	# Quitter le jeu
	get_tree().quit()


func _on_name_text_changed(new_text: String) -> void: ## Active ou désactive le bouton de jeu
	if len($name.text) == 0:
		$PlayButton.disabled = true
	
	else:
		$PlayButton.disabled = false
	


func _on_saves_button_pressed() -> void:
	
	if save_script.get_saved_players().is_empty():
		$NoSaveWindow.visible = true
		for button in get_tree().get_nodes_in_group("menu_buttons"):
			button.disabled = true
	
	else:
		$NoSaveWindow.visible = false
		# Désactiver les boutons du premier niveau de menu
		for button in get_tree().get_nodes_in_group("menu_buttons"):
			button.disabled = true
		
		$SavesWindow.visible = true





func _on_saves_window_close_requested() -> void:
	$SavesWindow.visible = false
	# Réactiver les boutons du premier niveau de menu
	for button in get_tree().get_nodes_in_group("menu_buttons"):
		button.disabled = false


func _on_no_save_window_close_requested() -> void:
	$NoSaveWindow.visible = false
	for button in get_tree().get_nodes_in_group("menu_buttons"):
			button.disabled = false
