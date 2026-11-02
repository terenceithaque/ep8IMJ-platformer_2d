extends Window

const SAVE = preload("res://scripts/save.gd")
@onready var save_script = SAVE.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player in save_script.get_saved_players():
		var player_name_label = Label.new()
		player_name_label.text = player
		add_child(player_name_label)
		player_name_label.add_to_group("player_profiles")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_saves_window_pressed() -> void:
	visible = false
	close_requested.emit()
