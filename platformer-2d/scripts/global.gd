extends Node
var SAVE = preload("res://scripts/save.gd")
@onready var save_script = SAVE.new()

var player_name = "player"
var player_save_state = {}
var level_save_state = {}

var camera_limit_left = -200.0
var camera_limit_top = -1500.0
var camera_limit_right = 1500.0
var camera_limit_bottom = 1200.0


var saved_players : PackedStringArray

func _ready():
	saved_players = save_script.get_saved_players()

func set_player_name(name:String) -> void:
	player_name = name
	print("Nom du joueur défini :", player_name)
	

func update_saved_players(): ## Actualise la liste des noms de joueurs sauvegardés
	saved_players = save_script.get_saved_players()
