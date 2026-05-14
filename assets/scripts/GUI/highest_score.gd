class_name HighestScoreGUI extends PanelContainer

@onready var points_label: Label = $"Score VBoxContainer/Points Label"

func _ready() -> void:
	points_label.text = "0000"

func set_highest_score(score: int):
	points_label.text = str(score)
