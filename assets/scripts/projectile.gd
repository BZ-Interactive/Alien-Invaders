extends Area2D

var shot : bool = false
var direction : Vector2 = Vector2.UP
var speed : float = 250
@export var damage : float = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (shot):
		position += delta * speed * direction
	pass

func shoot(dir : Vector2, spd : float = 250):
	self.direction = dir
	self.speed = spd
	self.rotation = direction.angle() + deg_to_rad(90)
	shot = true

func _on_body_entered(body: Node) -> void:
	if body.has_method("damage"):
		body.damage(damage);
		self.queue_free()

# self free, prevent infinite lifetime
func _on_life_time_timer_timeout() -> void:
	queue_free()
