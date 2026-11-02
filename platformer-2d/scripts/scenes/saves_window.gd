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
		add_child(player_name_button)
		player_name_button.add_to_group("player_profiles")
		button_y += button_spacing_y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_saves_window_pressed() -> void:
	visible = false
	close_requested.emit()
