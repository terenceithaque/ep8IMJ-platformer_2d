extends Window

const SAVE = preload("res://scripts/save.gd")
@onready var save_script = SAVE.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var button_y = 0 # Coordonnée y du bouton
	var button_spacing_y = 55 # Espacement appliqué entre chaque bouton
	
	for player in save_script.get_saved_players():
		var player_name_button = MenuButton.new()
		player_name_button.text = player
		player_name_button.flat = false
		player_name_button.position.y = button_y
		
		# Ajouter des options au menu déroulant du bouton
		var button_popup = player_name_button.get_popup()
		button_popup.add_item("Jouer sur cette sauvegarde")
		button_popup.add_item("Supprimer cette sauvegarde")
		button_popup.id_pressed.connect(func(id:int): _on_profile_option_selected(id, button_popup, player))
		
		
		#player_name_button.connect("pressed", func(): _on_player_name_button_clicked(player))
		add_child(player_name_button)
		player_name_button.add_to_group("player_profiles")
		button_y += button_spacing_y
		



func _on_profile_option_selected(id:int, popup:PopupMenu, player_name:String) -> void:
	
	# Effectuer l'opération correspondant à l'option
	match id:
		0: pass
		1: save_script.rm_player_save(player_name)
	

func _on_close_saves_window_pressed() -> void:
	visible = false
	close_requested.emit()
