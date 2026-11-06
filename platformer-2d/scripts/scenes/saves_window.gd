extends Window

const SAVE = preload("res://scripts/save.gd")
@onready var save_script = SAVE.new()

var player_to_delete = ""


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
		

func update_profiles_buttons() -> void: ## Actualise les boutons d'action sur les profils de sauvegarde
	
	# Supprimer les boutons déjà existants
	for profile_button in get_tree().get_nodes_in_group("player_profiles"):
		profile_button.remove_from_group("player_profiles")
		remove_child(profile_button)
	
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
	
	if id == 0:
		print("Nom du joueur dont la sauvegarde doit être chargée :", player_name)
		var save_data = save_script.open_player_save(player_name)
		Global.player_save_state = save_data["mainchar"]
		Global.level_save_state = save_data["levels"]
		#Global.player_name = player_name
		get_tree().change_scene_to_file(Global.player_save_state["level"])
		
	
	elif id == 1:
		$DeleteSaveConfirm.visible = true
		player_to_delete = player_name


func _on_close_saves_window_pressed() -> void:
	visible = false
	close_requested.emit()


func _on_delete_save_confirm_confirmed() -> void:
	
	save_script.rm_player_save(player_to_delete)
	update_profiles_buttons()
