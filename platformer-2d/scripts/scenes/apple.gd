extends RigidBody2D

var consumed = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func play_bite_sound():
	$sound.play()

func serialize_data() -> Dictionary: ## Convertit l'état de la pomme en un dictionnaire
	var data = {
		"consumed": consumed,
		"visible": $sprite.visible,
		"disabled": $collision_shape.disabled,
		"groups": get_groups()}
	
	return data

func set_state(save_dict:Dictionary) -> void:
	consumed = save_dict["consumed"]
	$sprite.visible = save_dict["visible"]
	$collision_shape.disabled = save_dict["disabled"]
	
	# Ajouter le noeud aux groupes correspondants
	for group in save_dict["groups"]:
		add_to_group(group)

func dissapear() -> void: ## Cache le sprite de la pomme et désactive sa boîte de collision
	$sprite.visible = false
	$collision_shape.disabled = true
