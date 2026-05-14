class_name EnemySpawner extends Node2D

@onready var enemy_manager: EnemyManager = $".."
@export var basic_enemy_scene: PackedScene
var expected_time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_enemies()

func spawn_enemies():
	var spawned_count = 0
	while spawned_count < enemy_manager.number_of_enemies:
		spawn_enemy()
		spawned_count += 1
	
	GameManager.current_game_scene.expected_time = expected_time

func spawn_enemy() -> void:
	var enemy = basic_enemy_scene.instantiate() as Enemy
	enemy_manager.add_enemy(enemy)
	expected_time += enemy.time_addition
