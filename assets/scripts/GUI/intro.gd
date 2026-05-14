extends CenterContainer

@onready var org_logo : TextureRect = $"Org Logo TextureRect"
@onready var icon_parent : TextureRect = $"Icon Background TextureRect"
@onready var wait_timer : Timer = $"Wait Timer"
@export var fade_time : float = 1.25

@export var gui_scene : PackedScene

var skipable = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var color_delay_time = fade_time / 2
	org_logo.modulate.a = 0
	icon_parent.modulate.a = 0
	
	# basic wait for the screen initialization
	wait_timer.start()
	# called here for masking with the intro
	SceneLoader.load_threaded(gui_scene.resource_path)
	await wait_timer.timeout
	
	var tween = create_tween()
	tween.tween_property(org_logo, "modulate:a", 1.0, fade_time).set_trans(Tween.TRANS_LINEAR)
	
	# Fade out org_logo
	await tween.finished
	tween = create_tween()
	tween.tween_property(org_logo, "modulate:a", 0.0, fade_time).set_trans(Tween.TRANS_LINEAR).set_delay(fade_time)
	
	# guarantee gui scene load by this time
	skipable = true
	
	wait_timer.start()
	await wait_timer.timeout
	
	# Fade in icon_parent
	await tween.finished
	tween = create_tween()
	tween.tween_property(icon_parent, "modulate:a", 1.0, 1.25).set_trans(Tween.TRANS_LINEAR)

	# Fade out icon_parent
	await tween.finished
	tween = create_tween()
	tween.parallel().tween_property(icon_parent, "self_modulate:r", 0, fade_time).set_trans(Tween.TRANS_LINEAR).set_delay(color_delay_time)
	tween.parallel().tween_property(icon_parent, "self_modulate:g", 0, fade_time).set_trans(Tween.TRANS_LINEAR).set_delay(color_delay_time)
	tween.parallel().tween_property(icon_parent, "self_modulate:b", 0, fade_time).set_trans(Tween.TRANS_LINEAR).set_delay(color_delay_time)
	tween.parallel().tween_property(icon_parent, "modulate:a", 0.0, fade_time).set_trans(Tween.TRANS_LINEAR).set_delay(fade_time)
	
	# delete intro
	await tween.finished
	
	# smooth transition to menu
	tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a", 0.0, 1).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	
	queue_free()

func _input(event: InputEvent) -> void:
	# space, enter and escape can skip intro
	if skipable and event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept"):
		queue_free()
