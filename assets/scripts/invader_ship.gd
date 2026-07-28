class_name Invader extends Enemy

func _process(delta: float) -> void:
	follow_player()
	pass

func follow_player() -> void:
	var y_pos = GameManager.current_game_scene.player.position.y + 60
	self.position = Vector2i(self.position.x , self.position.y)
