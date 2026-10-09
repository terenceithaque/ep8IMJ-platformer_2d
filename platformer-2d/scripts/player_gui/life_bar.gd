extends ProgressBar


func update(player_life:int, max_life:int) -> void: ## Met à jour la barre de vie du joueur
	value = player_life * 100 / max_life
