class_name ScriptedAnimation extends AnimatedSprite2D

@export var fade_duration: float = 0.25
signal animation_complete

func _ready() -> void:
	self.play()
	await self.animation_finished
	var tween = create_tween().tween_property(self, "modulate", Color.TRANSPARENT, fade_duration)
	animation_complete.emit()
	await tween.finished
	self.queue_free()
