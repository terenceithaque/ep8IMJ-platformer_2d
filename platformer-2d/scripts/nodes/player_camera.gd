extends Camera2D


# Limites par défaut de la caméra (peuvent être modifiées au besoin)
var default_limit_left = -200.0
var default_limit_top = -1500.0
var default_limit_right = 1500.0
var default_limit_bottom = 1200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Limites actuelles de la caméra
	limit_left = default_limit_left
	limit_top = default_limit_top
	limit_right = default_limit_right
	limit_bottom = default_limit_bottom


func set_limits(left:float, top:float, right:float, bottom:float) -> void: ## Redéfinit les limites de la caméra selon les valeurs de gauche, haut, droite et bas indiquées. Cela n'affecte pas les limites par défaut. L'effet de cette fonction peut être annulé par reset_limits().
	
	# Redéfinir les limites actuelles de la caméra
	limit_left = left
	limit_top = top
	limit_right = right
	limit_bottom = bottom


func reset_limits() -> void: ## Réinitialise les limites actuelles de la caméra, suivant les limites par défaut établies.
	
	# Réinitialiser les limites actuelles de la caméra
	limit_left = default_limit_left
	limit_top = default_limit_top
	limit_right = default_limit_right
	limit_bottom = default_limit_bottom
	

func set_default_limits(left:float, top:float, right:float, bottom:float) -> void: ## Redéfinit les limites par défaut de la caméra selon les valeurs de gauche, haut droite et bas indiquées. Attention ! Contrairement à set_limits(), l'effet de cette fonction est irréversible.
	
	# Redéfinir les limites par défaut de la caméra
	default_limit_left = left
	default_limit_top = top
	default_limit_right = right
	default_limit_bottom = bottom
