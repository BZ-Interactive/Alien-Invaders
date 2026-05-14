extends CenterContainer

# Level finished variables
@onready var won_panel: PanelContainer = $"PanelContainer/MarginContainer/VBoxContainer/Won PanelContainer"
@onready var lost_panel: PanelContainer = $"PanelContainer/MarginContainer/VBoxContainer/Lost PanelContainer"

# Score variables
@onready var total_score_label: Label = $"PanelContainer/MarginContainer/VBoxContainer/Score PanelContainer/VBoxContainer/Total Score Label"
@onready var enemy_points: Label = $"PanelContainer/MarginContainer/VBoxContainer/Score PanelContainer/VBoxContainer/Enemy HBoxContainer/Enemy Points Label"
@onready var survived_points: Label = $"PanelContainer/MarginContainer/VBoxContainer/Score PanelContainer/VBoxContainer/Survived HBoxContainer/Survived Points Label"
@onready var time_points: Label = $"PanelContainer/MarginContainer/VBoxContainer/Score PanelContainer/VBoxContainer/Time HBoxContainer/Time Points Label"

func game_won():
	lost_panel.visible = false
	won_panel.visible = true
	_end_game()

func game_lost():
	won_panel.visible = false
	lost_panel.visible = true
	_end_game()

func on_return_button():
	GameManager.normal_time_scale()
	self.visible = false
	GameManager.main_menu.visible = true
	GameManager.game_ended = false
	GameManager.current_game_scene.queue_free()

func _end_game():
	GameManager.slow_time_scale()
	var survived = false
	if won_panel.visible:
		survived = true
	var game_result = ScoreManager.calculate_level_score(survived, GameManager.current_game_scene.level_timer.time_left, GameManager.current_game_scene)
	total_score_label.text = str(game_result.total)
	enemy_points.text = str(game_result.enemy)
	survived_points.text = str(game_result.survived)
	time_points.text = str(game_result.time)
	self.visible = true
	ScoreManager.reset_current_score()
	
