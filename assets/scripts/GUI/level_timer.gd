extends PanelContainer

@export var runner: bool = false

@onready var time_label: Label = $"VBoxContainer/Time Left Label"
@onready var bonus_label: Label = $"VBoxContainer/For Bonus Label"
@onready var lost_bonus_label: Label = $"VBoxContainer/Bonus Lost Label"
@onready var runner_label: HBoxContainer = $"VBoxContainer/Runner HBoxContainer"
@onready var wave_label: Label = $"VBoxContainer/Runner HBoxContainer/Wave Number Label"

func _ready() -> void:
	time_label.self_modulate = Color.WHITE
	lost_bonus_label.visible = false
	bonus_label.visible = true
	
	if runner:
		runner_label.visible = true
		bonus_label.visible = false
	else:
		runner_label.visible = false
		bonus_label.visible = true
	
	await get_tree().process_frame
	set_process(false)
	if runner and GameManager.current_game_mode == GameMode.Type.RUNNER:
		
		set_process(true)
	if not runner and GameManager.current_game_mode == GameMode.Type.SHOOTER:
		set_process(true)

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

func set_wave(number: int):
	wave_label.text = str(number)
