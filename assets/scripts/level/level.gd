extends Node2D

@export var is_infininite : bool = false
@export var projectile_parent : Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_game_scene = self
