extends StaticBody2D


var collected = false

func _ready():
	$sprite.play("turn")
	

func serialize_data() -> Dictionary: ## Regroupe les données de la pièce dans un dictionnaire utilisable pour une sauvegarde
	var data = {
		"collected": collected,
		"visible": $sprite.visible,
		"disabled": $CollisionShape2D.disabled,
	}
	
	return data
	

func set_state(save_dict:Dictionary) -> void: ## Actualise l'état de la pièce selon le dictionnaire de sauvegarde indiqué
	collected = save_dict["collected"]
	$sprite.visible = save_dict["visible"]
	$CollisionShape2D.disabled = save_dict["disabled"]

func dissapear(): ## Rend le sprite de la pièce invisible et désactive la boîte de collision
	$sprite.visible = false
	$CollisionShape2D.disabled = true

func play_collected_sound():
	if collected:
		$collected.play()
		
		
		
func _on_collected_finished() -> void:
	
	queue_free()


func _on_sprite_animation_finished() -> void:
	$sprite.play("turn")
