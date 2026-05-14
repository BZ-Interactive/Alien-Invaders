class_name Enemy extends CharacterBody2D # this won't move for now in the future will

@export var projectile : PackedScene
const shooting_direction = Vector2.DOWN
var row_offset : float

# has to be between 0.0 and 1.0
@export var shoot_chance : float = 0.5
@onready var cooldown_timer : Timer = $"Cooldown Timer"

@export var health : float = 1.0

@export_category("Power up")
@export var power_up_chance : float = 0.1 # has to be between 0.0 and 1.0
@export var points:int = 100
@export var time_addition:float = 2.0 # seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooldown_timer.wait_time = randf_range(1, 4)
	cooldown_timer.start()
	_Engeage()
	
func _drop_power_up() -> void:
	if randf() <= power_up_chance:
		var powerup = PowerupManager.Instance.get_power_rand_up().instantiate()
		GameManager.current_game_scene.projectile_parent.add_child.call_deferred(powerup)
		powerup.position = self.position
		pass

# raycast check with row offset distance
func _is_not_obstructed() -> bool:
	var space_state = get_world_2d().direct_space_state

	var from = position
	var to = position + (shooting_direction.normalized() * row_offset)

	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self.get_rid()] # ignore self

	var result = space_state.intersect_ray(query)
	return result.is_empty()

# basic rng based coin flip logic
func _will_shoot() -> bool:
	return randf() <= shoot_chance

func _Engeage() -> void:
	while health > 0:
		await cooldown_timer.timeout
		if _will_shoot() and _is_not_obstructed():
			_shoot()
			cooldown_timer.wait_time = randf_range(1, 4)
		cooldown_timer.start()

func _shoot() -> void:
	var shot = projectile.instantiate()
	shot.position = self.global_position + shooting_direction * 50
	shot.shoot(shooting_direction)
	GameManager.current_game_scene.projectile_parent.add_child(shot)

func _die():
	ScoreManager.add_points(points)
	GameManager.enemy_manager.decrement_enemy_count()
	self.queue_free()

func damage(dmg : float) -> void:
	self.health -= dmg
	if health <= 0:
		_drop_power_up()
		_die()
