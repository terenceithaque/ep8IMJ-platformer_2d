extends Node


func create_saves_dir() -> void: ## Crée le dossier de sauvegardes du jeu
	var user_dir = DirAccess.open("user://")
	print(ProjectSettings.globalize_path("user://"))
	
	if not user_dir.dir_exists("saves"):
		user_dir.make_dir("saves")

func create_player_save(player_name:String) -> void: ## Crée un dossier de sauvegarde nommé d'après le nom de joueur donné en paramètre
	var saves_dir = DirAccess.open("user://saves")
	
	saves_dir.make_dir(player_name)
	
	# Créer les sous-dossiers nécessaires
	var player_save_dir = DirAccess.open("user://saves/{0}".format([player_name]))
	
	player_save_dir.make_dir("mainchar")
	player_save_dir.make_dir("levels")


func save_player(player_data:Dictionary) -> void: ## Sauvegarde les données de joueur passées en paramètre dans un fichier JSON
	
	# Récupérer le nom du joueur
	var player_name = player_data["player_name"]
	
	if not player_name in get_saved_players():
		create_player_save(player_name)
	
	# Accéder au sous-dossier "mainchar"
	var mainchar_dir = DirAccess.open("user://saves/{0}/mainchar".format([player_name]))
	
	var json_file = FileAccess.open("user://saves/{0}/mainchar/data.json".format([player_name]), FileAccess.WRITE)
	
	json_file.store_line(JSON.stringify(player_data))

func save_level(player_name:String, level_data:Dictionary) -> void: ## Sauvegarde les données du niveau passées en paramètre dans un fichier JSON
	
	# Accéder au sous-dossier "levels"
	var levels_dir = DirAccess.open("user://saves/{0}/levels".format([player_name]))
	var level_file = FileAccess.open("user://saves/{0}/levels/data.json".format([player_name]),FileAccess.WRITE)
	level_file.store_line(JSON.stringify(level_data))
	
func get_saved_players(): ## Renvoie une liste contenant le nom des joueurs ayant un dossier de sauvegarde
	var saves_dir = DirAccess.open("user://saves")
	
	return saves_dir.get_directories()
