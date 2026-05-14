class_name MainMenu extends Control

@export var game_scene : PackedScene
@export var infinite_scene : PackedScene

@onready var highest_score: HighestScoreGUI = $"PanelContainer/MarginContainer/Left Side VSplitContainer/Highest Score"

func _init() -> void:
	GameManager.main_menu = self

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
