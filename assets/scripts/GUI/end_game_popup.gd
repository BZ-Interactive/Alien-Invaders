extends CenterContainer

## Level finished variables
@onready var won_panel: PanelContainer = $"PanelContainer/MarginContainer/VBoxContainer/Won PanelContainer"
@onready var lost_panel: PanelContainer = $"PanelContainer/MarginContainer/VBoxContainer/Lost PanelContainer"
@onready var runner_panel: PanelContainer = $"PanelContainer/MarginContainer/VBoxContainer/Runner PanelContainer"

## Shooter Score variables
@onready var total_score_label: Label = $"PanelContainer/MarginContainer/VBoxContainer/Score PanelContainer/VBoxContainer/Total Score Label"
@onready var enemy_points: Label = $"PanelContainer/MarginContainer/VBoxContainer/Score PanelContainer/VBoxContainer/Enemy HBoxContainer/Enemy Points Label"
@onready var survived_points: Label = $"PanelContainer/MarginContainer/VBoxContainer/Score PanelContainer/VBoxContainer/Survived HBoxContainer/Survived Points Label"
@onready var time_points: Label = $"PanelContainer/MarginContainer/VBoxContainer/Score PanelContainer/VBoxContainer/Time HBoxContainer/Time Points Label"

## Score Panels
@onready var shooter_score: VBoxContainer = $"PanelContainer/MarginContainer/VBoxContainer/Score PanelContainer/VBoxContainer"
@onready var runner_score: VBoxContainer = $"PanelContainer/MarginContainer/VBoxContainer/Score PanelContainer/Runner VBoxContainer"

@onready var run_enemy_points: Label = $"PanelContainer/MarginContainer/VBoxContainer/Score PanelContainer/Runner VBoxContainer/Enemy HBoxContainer/Enemy Points Label"
@onready var wave_points: Label = $"PanelContainer/MarginContainer/VBoxContainer/Score PanelContainer/Runner VBoxContainer/Wave HBoxContainer/Wave Points Label"
@onready var run_total_score_label: Label = $"PanelContainer/MarginContainer/VBoxContainer/Score PanelContainer/Runner VBoxContainer/Total Score Label"

func game_won():
	lost_panel.visible = false
	won_panel.visible = true
	runner_panel.visible = false
	shooter_score.visible = true
	runner_score.visible = false
	_end_game()

func game_lost():
	won_panel.visible = false
	lost_panel.visible = true
	runner_panel.visible = false
	shooter_score.visible = true
	runner_score.visible = false
	_end_game()

func runner_end():
	won_panel.visible = false
	lost_panel.visible = false
	runner_panel.visible = true
	shooter_score.visible = false
	runner_score.visible = true
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
	
	run_enemy_points.text = str(game_result.enemy)
	wave_points.text = str(game_result.wave)
	run_total_score_label.text = str(game_result.total)
	
	self.visible = true
	ScoreManager.reset_current_score()
	
