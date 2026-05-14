extends CanvasLayer

@onready var pause_menu : CenterContainer = $"Pause Menu CenterContainer"
@onready var game_end_popup : CenterContainer = $"End Game Popup"

func _init() -> void:
	GameManager.current_hud = self

func _ready() -> void:
	pause_menu.visible = false
	game_end_popup.visible = false

func _input(event: InputEvent) -> void:
	if not GameManager.game_ended and event.is_action_pressed("Menu"):
		toggle_menu()

func toggle_menu():
	if not pause_menu.visible:
		pause_menu.visible = true
		GameManager.slow_time_scale()
	else:
		pause_menu.visible = false
		GameManager.normal_time_scale()

func on_resume_button():
	toggle_menu() # must be visible

func on_return_button():
	toggle_menu() # must be visible
	GameManager.game_left()
