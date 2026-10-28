extends Node


func create_saves_dir() -> void: ## Crée le dossier de sauvegardes du jeu
	var user_dir = DirAccess.open("user://")
	print(ProjectSettings.globalize_path("user://"))
	
	if not user_dir.dir_exists("saves"):
		user_dir.make_dir("saves")

func create_player_save(player_name:String) -> void: ## Crée un dossier de sauvegarde nommé d'après le nom de joueur donné en paramètre
	var saves_dir = DirAccess.open("user://saves")
	
	saves_dir.make_dir(player_name)
	
func get_saved_players(): ## Renvoie une liste contenant le nom des joueurs ayant un dossier de sauvegarde
	var saves_dir = DirAccess.open("user://saves")
	
	return saves_dir.get_directories()
