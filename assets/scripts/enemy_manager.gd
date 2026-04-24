extends Node2D

@export var number_of_enemies : int
# order via indices: -- 6-4-2-0-1-3-5 --
@export var enemy_parent : Node2D
@export var enemy_placements : Array[Marker2D]
@export var row_offset : float
var current_count : int
var row_count : int

func _ready() -> void:
	row_count = 0
	GameManager.enemy_ship_count = number_of_enemies

func add_enemy(body : CharacterBody2D):
	enemy_parent.add_child.call_deferred(body)
	body.row_offset = row_offset
	
	# basically if 3rd enemy then 3 + 1 = 4th pos which would be 2nd place on left
	body.position = enemy_placements[current_count % len(enemy_placements)].position
	body.position.y -= row_offset * row_count
	
	current_count += 1
	if current_count > len(enemy_placements):
		row_count += 1
		current_count = 0
