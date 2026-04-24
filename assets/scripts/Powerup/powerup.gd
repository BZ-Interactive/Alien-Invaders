extends Area2D

@export var power_type = "gatling" # Better as enum quick to test as string
@export var drop_speed : float = 100
@export var time : float = 2 # in seconds

func _process(delta: float) -> void:
	self.position.y += drop_speed * delta
	pass

func _on_PowerUp_body_entered(body : Node2D):
	if body.is_in_group("player"):
		if body.has_method("power_up"):
			body.power_up(power_type, time)
			queue_free() # Remove the power-up from the scene
