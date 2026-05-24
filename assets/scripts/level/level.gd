class_name Level extends Node2D

@export var is_infininite: bool = false
@onready var projectile_parent: Node2D = $"Projectile Parent"

@export var expected_time: float = 0
@onready var level_timer: Timer = $"Level Timer"

@onready var player_pos_marker: Marker2D = $"Player Pos Marker2D"

func _init() -> void:
	GameManager.current_game_scene = self
	
func _ready() -> void:
	level_timer.wait_time = expected_time
	level_timer.start()
