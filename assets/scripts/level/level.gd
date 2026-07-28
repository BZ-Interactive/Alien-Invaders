class_name Level extends Node2D

@export var is_infininite: bool = false
@onready var projectile_parent: Node2D = $"Projectile Parent"

@export var expected_time: float = 0
@onready var level_timer: Timer = $"Level Timer"

@onready var player_pos_marker: Marker2D = $"Player Pos Marker2D"

var player: Player

## runner variables
var wave: int = 1
@export var wave_points: int = 1000

func _ready() -> void:
	await get_tree().process_frame
	level_timer.wait_time = expected_time
	level_timer.start()
	GameManager.current_hud.runner_time_panel.set_wave(wave)

## this is for runner level
func on_timer_timeout():
	if GameManager.game_ended:
		level_timer.Stop()
	
	if is_infininite and GameManager.current_game_mode == GameMode.Type.RUNNER:
		wave += 1
		GameManager.current_hud.runner_time_panel.set_wave(wave)
		#ScoreManager.add_points((wave - 1) * wave_points)
		level_timer.wait_time = expected_time
		level_timer.start()
