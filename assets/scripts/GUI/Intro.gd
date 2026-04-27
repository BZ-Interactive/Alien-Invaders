extends CenterContainer

@export var org_logo : TextureRect 
@export var icon_parent : TextureRect
@export var timer : Timer

@onready var fade_tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	org_logo.modulate.a = 0
	icon_parent.modulate.a = 0
	
	timer.start()
	await timer.timeout
	
	var tween = create_tween()
	tween.tween_property(org_logo, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_LINEAR)

	# Fade out org_logo
	await tween.finished
	tween = create_tween()
	tween.tween_property(org_logo, "modulate:a", 0.0, 1.5).set_trans(Tween.TRANS_LINEAR).set_delay(1.5)
	
	#await get_tree().create_timer(1.0).timeout
	timer.start()
	await timer.timeout
	
	# Fade in icon_parent
	await tween.finished
	tween = create_tween()
	tween.tween_property(icon_parent, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_LINEAR)

	# Fade out icon_parent
	await tween.finished
	tween = create_tween()
	tween.parallel().tween_property(icon_parent, "self_modulate:r", 0, 1.5).set_trans(Tween.TRANS_LINEAR).set_delay(1)
	tween.parallel().tween_property(icon_parent, "self_modulate:g", 0, 1.5).set_trans(Tween.TRANS_LINEAR).set_delay(1)
	tween.parallel().tween_property(icon_parent, "self_modulate:b", 0, 1.5).set_trans(Tween.TRANS_LINEAR).set_delay(1)
	tween.parallel().tween_property(icon_parent, "modulate:a", 0.0, 1.5).set_trans(Tween.TRANS_LINEAR).set_delay(1.5)
