extends Popup

var completion_flag = {
	"name":"",
	"completed":false}

func set_popup_title(popup_title): ## Définit le titre de la popup
	title = popup_title


func set_popup_text(popup_text):
	$text_content.text = popup_text
	

func set_visibility(visibility_setting): ## Change le paramètre de visibilité de la popup
	visible = visibility_setting
	

func set_completion_flag_name(flag_name:String) -> void: ## Définit le nom du drapeau de complétion
	completion_flag["name"] = flag_name

func set_completion_flag_value(flag_value:bool) -> void: ## Définit la valeur du drapeau de complétion
	completion_flag["completed"] = flag_value	
	
	

func _ready():
	$tutorial_sound.play()




func _on_popup_hide() -> void:
	set_completion_flag_value(true)
	print(completion_flag)
