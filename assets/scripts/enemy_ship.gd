class_name Enemy extends CharacterBody2D # this won't move for now in the future will

@export var projectile: PackedScene
const shooting_direction = Vector2.DOWN
var row_offset: float

@onready var raycast = $RayCast2D

# has to be between 0.0 and 1.0
@export var shoot_chance: float = 0.5
@onready var cooldown_timer: Timer = $"Cooldown Timer"

@export var health: float = 1.0

@export_category("Power up")
@export var power_up_chance: float = 0.1 # has to be between 0.0 and 1.0
@export var points: int = 100
@export var time_addition: float = 2.0 # seconds

@export_category("Sprites and Animations")
@onready var idle_sprite: Sprite2D = $"Idle Sprite2D"
@onready var right_sprite: Sprite2D = $"Right Sprite2D"
@onready var left_sprite: Sprite2D = $"Left Sprite2D"

@export var death_anim: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooldown_timer.wait_time = randf_range(2, 4)
	cooldown_timer.start()
	GameManager.enemy_manager.enemy_movement.connect(on_enemy_movement)
	_change_movement_sprite(Vector2.ZERO) # used to reset the sprite
	_Engeage()
	
func _drop_power_up() -> void:
	if randf() <= power_up_chance:
		var powerup := PowerupManager.Instance.get_power_rand_up().instantiate()
		GameManager.current_game_scene.projectile_parent.add_child.call_deferred(powerup)
		powerup.global_position = self.global_position

# basic rng based coin flip logic
func _will_shoot() -> bool:
	return randf() <= shoot_chance

func _Engeage() -> void:
	while health > 0:
		await cooldown_timer.timeout
		if _will_shoot() and not raycast.is_colliding():
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
	GameManager.enemy_manager.enemy_movement.disconnect(on_enemy_movement)
	var anim = death_anim.instantiate() as ScriptedAnimation
	GameManager.current_game_scene.add_child.call_deferred(anim)
	anim.global_position = self.global_position
	var tween = create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 0.25)
	await tween.finished
	self.queue_free()

func damage(dmg : float) -> void:
	self.health -= dmg
	if health <= 0:
		_drop_power_up()
		_die()

func _change_movement_sprite(dir: Vector2):
	if dir.x < 0: # left
		idle_sprite.visible = false
		right_sprite.visible = false
		left_sprite.visible = true
	elif dir.x > 0: # right
		idle_sprite.visible = false
		left_sprite.visible = false
		right_sprite.visible = true
	else: # no horizontal movement
		left_sprite.visible = false
		right_sprite.visible = false
		idle_sprite.visible = true

func on_enemy_movement(dir: Vector2):
	_change_movement_sprite(dir)
