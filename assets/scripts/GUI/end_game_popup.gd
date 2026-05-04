extends CenterContainer

@export var panel : PanelContainer

@export var won_label : Label
@export var lost_label : Label

func game_won():
	GameManager.slow_time_scale()
	self.visible = true
	panel.self_modulate = Color.GREEN
	lost_label.visible = false
	won_label.visible = true

func game_lost():
	GameManager.slow_time_scale()
	self.visible = true
	panel.self_modulate = Color.RED
	won_label.visible = false
	lost_label.visible = true

func on_return_button():
	GameManager.normal_time_scale()
	self.visible = false
	GameManager.main_menu.visible = true
	GameManager.game_ended = false
	GameManager.current_game_scene.queue_free()
