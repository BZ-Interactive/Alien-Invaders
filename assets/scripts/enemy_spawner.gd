extends Node2D

@export var enemy_manager : Node2D
@export var basic_enemy_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_enemies()

func spawn_enemies():
	var spawned_count = 0
	while spawned_count <= enemy_manager.number_of_enemies:
		spawn_enemy()
		spawned_count += 1

func spawn_enemy() -> void:
	enemy_manager.add_enemy(basic_enemy_scene.instantiate())
