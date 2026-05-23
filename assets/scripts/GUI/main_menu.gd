class_name MainMenu extends Control

@export var game_scene: PackedScene
@export var infinite_scene: PackedScene

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
	SceneLoader.load_direct(game_scene.resource_path)
	self.visible = false

func on_infinte_pressed():
	SceneLoader.load_direct(infinite_scene.resource_path)
	self.visible = false

func on_exit_pressed():
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.location.reload();")
	else: # desktop, mobile etc.
		get_tree().quit()

func on_org_button():
	OS.shell_open(org_url)

func on_itch_button():
	OS.shell_open(itch_url)
