class_name MainMenu extends Control

var org_url: String = "https://github.com/BZ-Interactive"
var itch_url: String = "https://bz-interactive.itch.io/"

@onready var highest_score: HighestScoreGUI = $"PanelContainer/MarginContainer/Left Side VSplitContainer/Highest Score"

@onready var exit_button: Button = $"PanelContainer/MarginContainer/Left Side VSplitContainer/Buttons VBoxContainer/Exit Button"

func _init() -> void:
	GameManager.main_menu = self

func _ready() -> void:
	if OS.has_feature("web"):
		exit_button.text = "Reset"

func on_play_pressed():
	GameManager.load_scene(GameMode.Type.SHOOTER)
	self.visible = false

func on_runner_pressed():
	GameManager.load_scene(GameMode.Type.RUNNER)
	self.visible = false

func on_exit_pressed():
	GameManager.current_game_mode = GameMode.Type.EXIT
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.location.reload();")
	else: # desktop, mobile etc.
		get_tree().quit()

func on_org_button():
	OS.shell_open(org_url)

func on_itch_button():
	OS.shell_open(itch_url)
