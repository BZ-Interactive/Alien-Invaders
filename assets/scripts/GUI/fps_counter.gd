extends HBoxContainer
@onready var fps_value_label: Label = $"FPS Value Label"

# only active in game scenes, no need for other optimizations
func _process(_delta: float) -> void:
	fps_value_label.text = str(Engine.get_frames_per_second())
