extends Node2D

var enemy_manager: EnemyManager
var main_menu: MainMenu

var current_game_scene: Level
var current_hud: CanvasLayer

var slowed_time_scale: float = 0.1
var game_ended: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_ended = false

func game_won():
	_end_game()
	current_hud.game_end_popup.game_won()

func game_lost():
	_end_game()
	current_hud.game_end_popup.game_lost()

func game_left():
	current_hud.pause_menu.visible = false
	GameManager.normal_time_scale()
	GameManager.main_menu.visible = true
	GameManager.current_game_scene.queue_free()

func slow_time_scale():
	Engine.time_scale = GameManager.slowed_time_scale
	
func normal_time_scale():
	Engine.time_scale = 1.0

func _end_game():
	game_ended = true
	current_hud.pause_menu.visible = false
	current_game_scene.level_timer.paused = true
