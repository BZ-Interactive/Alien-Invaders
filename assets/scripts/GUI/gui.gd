extends Control

@export var game_scene : PackedScene

func on_play_pressed():
	SceneLoader.load_direct(game_scene.resource_path)

func on_exit_pressed():
	get_tree().quit()
