extends Node2D

@export var is_infininite : bool = false
@export var projectile_parent : Node2D
@export var game_end_popup : CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_game_scene = self
	game_end_popup.visible = false
