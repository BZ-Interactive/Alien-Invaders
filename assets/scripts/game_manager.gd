extends Node2D

@export var enemy_manager : Node2D
@export var main_menu : Control

var current_game_scene : Node2D
var current_hud : CanvasLayer

@export var slowed_time_scale : float = 0.1
var game_ended : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_ended = false

func game_won():
	game_ended = true
	current_hud.pause_menu.visible = false
	current_hud.game_end_popup.game_won()

func game_lost():
	game_ended = true
	current_hud.pause_menu.visible = false
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
