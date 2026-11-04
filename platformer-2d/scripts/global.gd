extends Node

var player_name = "player"
var player_save_state = {}
var level_save_state = {}


func set_player_name(name:String) -> void:
	player_name = name
	print("Nom du joueur défini :", player_name)
