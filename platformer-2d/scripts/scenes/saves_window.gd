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
		player_name_button.get_popup().add_item("Jouer sur cette sauvegarde")
		player_name_button.get_popup().add_item("Supprimer cette sauvegarde")
		
		#player_name_button.connect("pressed", func(): _on_player_name_button_clicked(player))
		add_child(player_name_button)
		player_name_button.add_to_group("player_profiles")
		button_y += button_spacing_y
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	print(get_tree().get_nodes_in_group("player_profiles"))
	for profile_button in get_tree().get_nodes_in_group("player_profiles"):
		var options = profile_button.get_popup()
		print(options.items)
		if options.is_item_checked(1):
			print("La deuxième option a été sélectionnée")
			save_script.rm_player_save(profile_button.text)

func _on_player_name_button_clicked(player_name:String) -> void:
	save_script.rm_player_save(player_name)
	

func _on_close_saves_window_pressed() -> void:
	visible = false
	close_requested.emit()
