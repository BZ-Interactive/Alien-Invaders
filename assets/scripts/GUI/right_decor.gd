extends Control

@export var main_menu : Control
@export var player : Sprite2D
@export var fighter : Sprite2D
@export var invader : Sprite2D

var fighter_speed : float = 200
var invader_speed : float = 200
var player_speed : float = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if main_menu.visible:
		move_player_up(delta)
		move_fighter_down(delta)
		move_invader_down(delta)

func move_fighter_down(delta: float):
	fighter.position.y += fighter_speed * delta

func move_invader_down(delta: float):
	invader.position.y += invader_speed * delta

func move_player_up(delta: float):
	player.position.y -= player_speed * delta

func on_player_left_screen():
	#50, 900, the limits are the limits of the parent control
	player.position = Vector2(randi_range(50, 900), 1000)
	player_speed = randf_range(100, 600)

func on_fighter_left_screen():
	#50, 900, the limits are the limits of the parent control
	fighter.position = Vector2(randi_range(50, 900), 0)
	fighter_speed = randf_range(100, 400)
	
func on_invader_left_screen():
	#50, 900, the limits are the limits of the parent control
	invader.position = Vector2(randi_range(50, 900), 0)
	invader_speed = randf_range(100, 400)
