extends CharacterBody2D # this won't move for now in the future will

@export var projectile : PackedScene
const shooting_direction = Vector2.DOWN
var row_offset : float

@export var shoot_chance : float = 0.5 # has to be between 0.0 and 1.0
@export var cooldown_timer : Timer # has to be between 0.0 and 1.0
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

@export var health : float = 1.0

@export_category("Power up")
@export var power_up_chance : float = 0.1 # has to be between 0.0 and 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooldown_timer.wait_time = rng.randf_range(1, 4)
	cooldown_timer.start()
	Engeage()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func drop_power_up() -> void:
	if randf() <= power_up_chance:
		var powerup = PowerupManager.Instance.get_power_rand_up().instantiate()
		get_tree().root.add_child.call_deferred(powerup)
		#powerup.owner = get_tree().root
		powerup.position = self.position
		pass

# raycast check with row offset distance
func is_not_obstructed() -> bool:
	var space_state = get_world_2d().direct_space_state

	var from = position
	var to = position + (shooting_direction.normalized() * row_offset)

	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self.get_rid()] # ignore self

	var result = space_state.intersect_ray(query)
	return result.is_empty()

# basic rng based coin flip logic
func will_shoot() -> bool:
	return rng.randf() <= shoot_chance

func Engeage() -> void:
	while (true):
		await cooldown_timer.timeout
		if will_shoot() and is_not_obstructed():
			shoot()
			cooldown_timer.wait_time = rng.randf_range(1, 4)
		cooldown_timer.start()

func shoot() -> void:
	var shot = projectile.instantiate()
	shot.position = self.global_position + shooting_direction * 50
	shot.shoot(shooting_direction)
	get_tree().root.add_child(shot)

func die():
	GameManager.enemy_ship_count -= 1
	self.queue_free()

func damage(dmg : float) -> void:
	# add damage and death logic here
	self.health -= dmg
	if health <= 0:
		drop_power_up()
		die()
