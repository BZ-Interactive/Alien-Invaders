extends CharacterBody2D

@export var projectile : PackedScene
const shooting_direction = Vector2.UP
 # better to use timer as its handled in Input
@export var fire_cooldown_timer : Timer
var can_fire : bool = false

# powerup variables
@export var powerup_timer : Timer
var current_power : String
var firerate_up : bool = false
var shield_up : bool = false
var speed_mult : float = 1 # 1 means no active power for speed

const SPRITE_SIZE = 50
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var health : float = 3.0

@export var shield_sprite : Sprite2D

@export var idle_visual : Sprite2D
@export var left_visual : Sprite2D
@export var right_visual : Sprite2D

@export_group("Sprites")
@export_subgroup("Standard")
@export var idle_standard : CompressedTexture2D
@export var left_standard : CompressedTexture2D
@export var right_standard : CompressedTexture2D

@export_subgroup("Powered Up")
@export var idle_powered : CompressedTexture2D
@export var left_powered : CompressedTexture2D
@export var right_powered : CompressedTexture2D

var dead : bool = false

func _ready() -> void:
	fire_cooldown_timer.timeout.connect(on_fire_cooldown_timeout)
	powerup_timer.timeout.connect(on_powerup_timeout)

func _input(event: InputEvent) -> void:
	if not dead and not GameManager.game_ended and event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_up"):
		shoot()

# physics based movement
func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if dead or GameManager.game_ended:
		return
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED * speed_mult
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	change_movement_sprite(direction)
	move_and_slide()
	
	# screen clamp
	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, -(screen_size.x / 2) + SPRITE_SIZE, screen_size.x / 2 - SPRITE_SIZE)

func power_up(power_type : String, time : float) -> void:
	reset_powerup()
	if power_type == "firerate":
		firerate_up = true
		idle_visual.texture = idle_powered
		left_visual.texture = left_powered
		right_visual.texture = right_powered
	elif power_type == "speed":
		speed_mult = 2
		modulate = Color.GREEN_YELLOW
	elif power_type == "shield":
		shield_up = true
		shield_sprite.visible = true
		
	current_power = power_type
	powerup_timer.wait_time = time
	powerup_timer.start()
	# can add effects

func change_movement_sprite(direction : float):
	if direction == 0.0 and not idle_visual.visible:
		idle_visual.visible = true
		left_visual.visible = false
		right_visual.visible = false
	elif direction < 0 and not left_visual.visible: # left
		idle_visual.visible = false
		left_visual.visible = true
		right_visual.visible = false
	elif direction > 0 and not right_visual.visible: # right
		idle_visual.visible = false
		left_visual.visible = false
		right_visual.visible = true

func shoot() -> void:
	if can_fire or firerate_up:
		can_fire = false
		var shot = projectile.instantiate()
		shot.shoot(shooting_direction)
		shot.position = global_position + shooting_direction * 50
		get_tree().root.add_child(shot)
		fire_cooldown_timer.start()

func reset_powerup():
	idle_visual.texture = idle_standard
	left_visual.texture = left_standard
	right_visual.texture = right_standard
	firerate_up = false
	shield_up = false
	speed_mult = 1
	modulate = Color.WHITE
	shield_sprite.visible = false

func on_fire_cooldown_timeout():
	can_fire = true
	
func on_powerup_timeout():
	reset_powerup()

func die():
	GameManager.game_lost()
	self.queue_free()

func damage(dmg : float) -> void:
	# add damage and death logic here
	if shield_up:
		return
	self.health -= dmg
	if health <= 0:
		die()
