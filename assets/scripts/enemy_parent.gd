extends Node2D

@onready var move_timer: Timer = $"../Move Timer"
@export var dir_move_limit: int = 2
@export var min_move_time: float = 1.5
@export var max_move_time: float = 5.0
var current_pos: Vector2 = Vector2.ZERO
@export var straight_move_chance: float = 0.8
var x_dir_array = [] # left, right
var y_dir_array = [] # up, down
var move_step: float
var enemy_manager: EnemyManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_timer.start()
	current_pos = Vector2.ZERO
	move_step = GameManager.enemy_manager.row_offset
	enemy_manager = GameManager.enemy_manager
	# initial wait for guaranteed init
	await move_timer.timeout
	move_enemies()

func decide_on_dir() -> Vector2:
	# two arrays will allow for directional movement
	var direction_array
	x_dir_array.clear()
	y_dir_array.clear()
	if current_pos.x < dir_move_limit: # can move right
		x_dir_array.append(Vector2.RIGHT)
		
	if current_pos.x > -dir_move_limit: # can move left
		x_dir_array.append(Vector2.LEFT)
		
	if current_pos.y > -dir_move_limit: # can move up
		y_dir_array.append(Vector2.UP)
	
	if current_pos.y < dir_move_limit: # can move down
		y_dir_array.append(Vector2.DOWN)
	
	if randi_range(0, 1) > straight_move_chance: # diagonal movement
		var x_move = x_dir_array[randi_range(0, len(x_dir_array) - 1)]
		var y_move = y_dir_array[randi_range(0, len(y_dir_array) - 1)]
		return x_move + y_move
	else: # single dir
		direction_array = x_dir_array + y_dir_array
		return direction_array[randi_range(0, len(direction_array) - 1)]

func move_enemies():
	var dir: Vector2
	while enemy_manager.number_of_enemies > 0:
		move_timer.start()
		await move_timer.timeout
		dir = decide_on_dir()
		current_pos += dir
		move_timer.wait_time = randf_range(min_move_time, max_move_time)
		var target_position:= position + dir * move_step
		enemy_manager.enemy_movement.emit(dir)
		var tween = create_tween().tween_property(self, "position", target_position, 1.0)
		await tween.finished
		enemy_manager.enemy_movement.emit(Vector2.ZERO)
