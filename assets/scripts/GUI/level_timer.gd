extends PanelContainer

@onready var time_label: Label = $"VBoxContainer/Time Left Label"
@onready var bonus_label: Label = $"VBoxContainer/For Bonus Label"
@onready var lost_bonus_label: Label = $"VBoxContainer/Bonus Lost Label"

func _ready() -> void:
	time_label.self_modulate = Color.WHITE
	lost_bonus_label.visible = false
	bonus_label.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# downed to 2 decimals for better looks
	if GameManager.current_game_scene.level_timer.time_left > 0:
		time_label.text = "%05.2f" % GameManager.current_game_scene.level_timer.time_left
	elif not lost_bonus_label.visible:
		lost_bonus_label.visible = true
		bonus_label.visible = false
		time_label.text = "00.00"
		time_label.self_modulate = Color.RED
