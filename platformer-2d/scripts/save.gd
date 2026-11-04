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
	
	var mainchar_dir_path = get_player_save_dir(player_name, "/mainchar")
	var mainchar_dir = DirAccess.open(mainchar_dir_path)
	
	var json_file = FileAccess.open(mainchar_dir_path + "/data.json", FileAccess.WRITE)
	
	print("Données sauvegardées du joueur :", JSON.stringify(player_data))
	json_file.store_line(JSON.stringify(player_data))
	

func is_save_valid(player_name:String) -> bool: ## Renvoie true si le dossier de sauvegarde du joueur indiqué existe et présente une structure valide, false sinon
	
	# Renvoyer false si le dossier de sauvegarde du joueur n'existe pas
	if not player_name in get_saved_players():
		return false
	
	else:
		var mainchar_dir = DirAccess.open(get_player_save_dir(player_name, "/mainchar"))
		var levels_dir = DirAccess.open(get_player_save_dir(player_name, "/levels"))
		
		if not "data.json" in mainchar_dir.get_files() or not "data.json" in levels_dir.get_files():
			return false
		
		else:
			return true

func get_player_save_dir(player_name:String, subdir:String="") -> String: ## Renvoie le chemin du dossier de sauvegarde du joueur indiqué
	return "user://saves/{0}".format([player_name]) + subdir

func rm_directory(path:String) -> void: ## Supprime récursivement un dossier et tout son contenu
	
	var directory = DirAccess.open(path)
		
	for file in directory.get_files():
		print(file)
		directory.remove(file)
	
	for subdir in directory.get_directories():
		print(path + "/" + subdir)
		rm_directory(path + "/" + subdir)
	
	DirAccess.remove_absolute(path)

	
func rm_player_save(player_name:String) -> void: ## Supprime l'intégralité du dossier de sauvegarde du joueur indiqué
	
	var save_dir_path = get_player_save_dir(player_name) # Chemin du dossier de sauvegarde
	print(save_dir_path)
	rm_directory(save_dir_path)
	
	
	

func save_level(player_name:String, level_data:Dictionary) -> void: ## Sauvegarde les données du niveau passées en paramètre dans un fichier JSON
	
	# Accéder au sous-dossier "levels"
	
	
	var levels_dir_path = get_player_save_dir(player_name, "/levels")
	print("Chemin du dossier de sauvegarde (levels) du joueur :", levels_dir_path)
	
	var levels_dir = DirAccess.open(levels_dir_path)
	var level_file = FileAccess.open(levels_dir_path + "/data.json", FileAccess.WRITE)
	level_file.store_line(JSON.stringify(level_data))

func open_player_save(player_name:String) -> Dictionary: ## Ouvre le dossier de sauvegarde d'un joueur et renvoie un dictionnaire avec tout le contenu de chacun des sous-dossiers
	
	var player_save_dir_path = get_player_save_dir(player_name)
	var mainchar_dir = DirAccess.open(player_save_dir_path + "/mainchar")
	var levels_dir = DirAccess.open(player_save_dir_path + "/levels")
	
	var mainchar_data = FileAccess.get_file_as_string(player_save_dir_path + "/mainchar/data.json")
	print("Mainchar data : ", mainchar_data)
	print(type_string(typeof(mainchar_data)))
	var mainchar_json = JSON.parse_string(mainchar_data)
	var levels_data = FileAccess.get_file_as_string(player_save_dir_path + "/levels/data.json")
	print("Levels data :", levels_data)
	var levels_json = JSON.parse_string(levels_data)
	
	var data = {
		"mainchar": mainchar_json,
		"levels": levels_json
	}
	
	return data
	
	
	
	
	
	
func get_saved_players(): ## Renvoie une liste contenant le nom des joueurs ayant un dossier de sauvegarde
	var saves_dir = DirAccess.open("user://saves")
	
	return saves_dir.get_directories()
