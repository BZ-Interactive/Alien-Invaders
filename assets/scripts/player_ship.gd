class_name Player extends CharacterBody2D

@export var projectile: PackedScene
const shooting_direction = Vector2.UP
 # better to use timer as its handled in Input
@onready var fire_cooldown_timer: Timer = $"Fire Cooldown Timer"
var can_fire: bool = false

# powerup variables
@onready var powerup_timer: Timer = $"Powerup Timer"
var current_power: String
var firerate_up: bool = false
var shield_up: bool = false
var speed_mult: float = 1 # 1 means no active power for speed

# powerup bar and styles
@onready var powerup_bar: ProgressBar = $"Powerup Bar"
@export var speed_style: StyleBoxFlat
@export var shield_style: StyleBoxFlat
@export var firerate_style: StyleBoxFlat

const SPRITE_SIZE = 50
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var health: float = 3.0
@onready var health_bar: ProgressBar = $"Health Bar"

@onready var shield_sprite: Sprite2D = $"Shield Sprite2D"

@onready var idle_visual: Sprite2D = $"Ship idle Sprite2D"
@onready var left_visual: Sprite2D = $"Ship Left Sprite2D"
@onready var right_visual: Sprite2D = $"Ship Right Sprite2D"

@export var death_anim: PackedScene

@export_group("Sprites")
@export_subgroup("Standard")
@export var idle_standard: CompressedTexture2D
@export var left_standard: CompressedTexture2D
@export var right_standard: CompressedTexture2D

@export_subgroup("Powered Up")
@export var idle_powered: CompressedTexture2D
@export var left_powered: CompressedTexture2D
@export var right_powered: CompressedTexture2D

var dead : bool = false
var entering : bool = false # for initial animation

func _ready() -> void:
	dead = false
	fire_cooldown_timer.timeout.connect(on_fire_cooldown_timeout)
	powerup_timer.timeout.connect(on_powerup_timeout)
	health_bar.value = self.health
	powerup_bar.visible = false
	_move_into_battle()

func _input(event: InputEvent) -> void:
	if not _check_input_blocked() and (event.is_action_pressed("shoot")):
		shoot()

# physics based movement
func _physics_process(_delta: float) -> void:
	if _check_input_blocked():
		_change_movement_sprite(0.0) # make sprite idle
		return
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED * speed_mult
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	_change_movement_sprite(direction)
	move_and_slide()
	
	# screen clamp
	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, -(screen_size.x / 2) + SPRITE_SIZE, screen_size.x / 2 - SPRITE_SIZE)

func _process(_delta: float) -> void:
	if powerup_bar.visible:
		powerup_bar.value = powerup_timer.time_left

func power_up(power_type : String, time : float) -> void:
	reset_powerup()
	if power_type == "firerate":
		firerate_up = true
		idle_visual.texture = idle_powered
		left_visual.texture = left_powered
		right_visual.texture = right_powered
		powerup_bar.add_theme_stylebox_override("fill", firerate_style)
	elif power_type == "speed":
		speed_mult = 2
		modulate = Color.GREEN_YELLOW
		powerup_bar.add_theme_stylebox_override("fill", speed_style)
	elif power_type == "shield":
		shield_up = true
		shield_sprite.visible = true
		powerup_bar.add_theme_stylebox_override("fill", shield_style)
		
	current_power = power_type
	powerup_timer.wait_time = time
	powerup_timer.start()
	powerup_bar.max_value = time
	powerup_bar.visible = true
	# can add effects

func _change_movement_sprite(direction : float):
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
		GameManager.current_game_scene.projectile_parent.add_child(shot)
		fire_cooldown_timer.start()

func reset_powerup():
	powerup_bar.visible = false
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
	dead = true
	var anim = death_anim.instantiate() as ScriptedAnimation
	GameManager.current_game_scene.add_child.call_deferred(anim)
	anim.global_position = self.global_position
	create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 0.75)
	await anim.animation_complete
	GameManager.game_lost()
	self.queue_free()

func take_damage(dmg : float) -> void:
	# add damage and death logic here
	if shield_up:
		return
	self.health -= dmg
	health_bar.value = self.health
	if health <= 0:
		die()

func _check_input_blocked() -> bool:
	return entering or dead or GameManager.game_ended or GameManager.current_hud.pause_menu.visible

func _move_into_battle():
	# must be first frame to manipulate positions
	entering = true
	await get_tree().process_frame  
	self.global_position = Vector2(0, 400) # just out of screen
	create_tween().tween_property(self, "global_position", GameManager.current_game_scene.player_pos_marker.global_position, 1.5)
	await get_tree().create_timer(2).timeout
	self.global_position = GameManager.current_game_scene.player_pos_marker.global_position
	entering = false
