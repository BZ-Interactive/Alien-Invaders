extends Node2D

@export var enemy_manager : Node2D
@export var current_game_scene : Node2D
@export var main_menu : Control


var game_ended : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_ended = false

func game_won():
	game_ended = true
	current_game_scene.game_end_popup.game_won()

func game_lost():
	game_ended = true
	current_game_scene.game_end_popup.game_lost()
