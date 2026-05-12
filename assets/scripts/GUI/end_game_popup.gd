extends CenterContainer

@export var panel : PanelContainer

@onready var won_panel : PanelContainer = $"PanelContainer/MarginContainer/VBoxContainer/Won PanelContainer"
@onready var lost_panel : PanelContainer = $"PanelContainer/MarginContainer/VBoxContainer/Lost PanelContainer"

func game_won():
	GameManager.slow_time_scale()
	self.visible = true
	lost_panel.visible = false
	won_panel.visible = true

func game_lost():
	GameManager.slow_time_scale()
	self.visible = true
	won_panel.visible = false
	lost_panel.visible = true

func on_return_button():
	GameManager.normal_time_scale()
	self.visible = false
	GameManager.main_menu.visible = true
	GameManager.game_ended = false
	GameManager.current_game_scene.queue_free()
