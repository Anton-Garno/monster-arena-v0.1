extends Node3D
@onready var main_menu : PanelContainer = $Menu/MainMenu
@onready var pause_menu: PanelContainer = $Menu/PauseMenu
@onready var player = $Player
var game_started : bool = false
var paused : bool = false

func _ready() -> void:
	game_started = false#game on pause(stop)
	get_tree().paused = true#check for logik
	main_menu.show()
	pause_menu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)#can use mouse in main menu game
	
	
func _process(delta: float) -> void:
	if  game_started:
		return
		
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("pause"):#global pause
		paused= !paused 
		get_tree().paused = paused
		pause_menu.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _on_start_button_pressed():#code for button on main menu(simple code in .gd button, check the code near line)
	game_started = true
	get_tree().paused= false
	main_menu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_resume_pressed():#button resume in main menu
	game_started = true
	get_tree().paused= false
	pause_menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
