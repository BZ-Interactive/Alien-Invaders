extends Node2D

@export var enemy_ship_count : int = 4

var game_ended : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_ended = false

func game_won():
	game_ended = true
	print("Won!!!")
	
func game_lost():
	game_ended = true
	print("Lost!!!")
