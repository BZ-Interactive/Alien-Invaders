class_name PowerupManager
extends Node
static var Instance : PowerupManager

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
@export var powerup_array : Array[PackedScene]

func _ready() -> void:
	Instance = self

func get_power_rand_up() -> PackedScene:
	var index = rng.randi_range(0, len(powerup_array) - 1)
	return powerup_array[index]
