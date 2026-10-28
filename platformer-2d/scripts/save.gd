extends Node


func create_save_dir() -> void: ## Crée le dossier de sauvegardes du jeu
	var user_dir = DirAccess.open("user://")
	print(ProjectSettings.globalize_path("user://"))
	
	if not user_dir.dir_exists("saves"):
		user_dir.make_dir("saves")
