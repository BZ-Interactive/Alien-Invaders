extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_width: float = 60
var enemy_diameter: float
var base_speed: float = -1.0

@export var spawn_amount: int = 1
 
@export var min_cooldown_time: float = 1.0
@export var max_cooldown_time: float = 6.0

@onready var enemy_parent: Node2D = $"../Enemy Parent"
@onready var timer: Timer = $"Spawn Timer"

var game_ended: bool = false
var size_x: float
var lane_number: int
var lanes: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size_x = get_viewport().get_visible_rect().size.x# - enemy_width
	lane_number = floor(get_viewport().get_visible_rect().size.x / enemy_width)
	enemy_diameter = enemy_width / 2.0
	Spawn()

func Spawn():
	while not game_ended:
		await timer.timeout
		lanes = range(1, lane_number)
		spawn_amount = GameManager.current_game_scene.wave
		spawn_amount = clampi(spawn_amount, 1, lane_number)
		for i in range(spawn_amount):
			var random_lane = get_random_lane()
			if random_lane < 0:
				continue
			move_to_lane(random_lane)
			instantiate_enemy()
			var waved_time = max_cooldown_time - ((max_cooldown_time - min_cooldown_time) / lane_number * (GameManager.current_game_scene.wave - 1))
			timer.wait_time = randf_range(min_cooldown_time, waved_time)

func get_random_lane() -> int:
	var index = randi_range(0, len(lanes) - 1)
	if len(lanes) > 0:
		var selected = lanes[index]
		lanes.remove_at(index)
		return selected
	else:
		return -1

func move_to_lane(lane: int):
	var new_x = (lane * enemy_width + enemy_diameter) - size_x / 2.0
	self.global_position = Vector2(new_x, self.global_position.y)

func instantiate_enemy():
	if not enemy_scene:
		return
	var enemy = enemy_scene.instantiate() as Enemy
	enemy.global_position = self.global_position
	if base_speed == -1.0:
		base_speed = enemy.runner_speed
	enemy.runner_speed = base_speed * pow(1.25, GameManager.current_game_scene.wave - 1)
	enemy_parent.call_deferred("add_child", enemy)
