extends CanvasLayer

@onready var pause_menu : CenterContainer = $"Pause Menu CenterContainer"
@onready var game_end_popup : CenterContainer = $"End Game Popup"

@onready var shooter_time_panel: PanelContainer = $"Shooter Time Panel"
@onready var runner_time_panel: PanelContainer = $"Runner Time Panel"

func _init() -> void:
	GameManager.current_hud = self

func _ready() -> void:
	pause_menu.visible = false
	game_end_popup.visible = false
	await get_tree().process_frame
	toggle_timer(GameManager.current_game_mode)

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

func toggle_timer(type: GameMode.Type):
	match type:
		GameMode.Type.RUNNER:
			shooter_time_panel.visible = false
			runner_time_panel.visible = true
		GameMode.Type.SHOOTER:
			shooter_time_panel.visible = true
			runner_time_panel.visible = false

func on_resume_button():
	toggle_menu() # must be visible

func on_return_button():
	toggle_menu() # must be visible
	GameManager.game_left()
