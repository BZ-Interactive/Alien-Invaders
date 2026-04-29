extends Node

var gui_path : String = "res://assets/scenes/gui.tscn"

const check_interval : float = 0.1
var last_check_time : float
var is_loading : bool = false

var queue : Array[String] = []

func _process(delta: float) -> void:
	if is_loading and check_interval < last_check_time:
		last_check_time = 0
		check_status_and_act()
		
		if len(queue) <= 0:
			is_loading = false
			set_process(false)
		
	elif is_loading:
		last_check_time += delta

func check_status_and_act():
	for path in queue:
		var status = ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			get_tree().root.add_child(ResourceLoader.load_threaded_get(path).instantiate())
			queue.erase(path)

## Threaded background loading
func load_threaded(path : String):
	ResourceLoader.load_threaded_request(path)
	queue.append(path)
	is_loading = true
	set_process(true)

## Standard blocking, load
func load_direct(path : String):
	get_tree().root.add_child(ResourceLoader.load(path).instantiate())
