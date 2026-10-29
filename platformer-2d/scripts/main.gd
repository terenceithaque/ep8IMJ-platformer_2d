extends Node

const SAVE = preload("res://scripts/save.gd")

@onready var save_script = SAVE.new()

var saved_players = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$music.play()
	$title.add_theme_font_override("font", load("res://assets/fonts/Isometra-Regular.ttf"))
	$PlayButton.disabled = true
	
	
	save_script.create_saves_dir()
	saved_players = save_script.get_saved_players()
	


func _on_play_button_pressed() -> void:
	# Lancer le premier niveau
	
	#get_tree().change_scene_to_file("res://scenes/intro.tscn")
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
	Global.set_player_name($name.text)
	print("Nom du joueur après défintion :", Global.player_name)
	if not $name.text in saved_players:
		save_script.create_player_save($name.text)
	



	


func _on_quit_button_pressed() -> void:
	# Quitter le jeu
	get_tree().quit()


func _on_name_text_changed(new_text: String) -> void: ## Active ou désactive le bouton de jeu
	if len($name.text) == 0:
		$PlayButton.disabled = true
	
	else:
		$PlayButton.disabled = false
	
