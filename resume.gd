extends Button
@onready var pause_menu:PanelContainer = $Menu/PauseMenu
@onready var game_started = get_node("../../../../..")
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("pause"):
		pass
		
