extends Node

var _effects = {
	"upgrade_explosion": preload("res://VFX/upgrade_explosion.tscn"),
	"destruction": preload("res://VFX/destruction.tscn"),
	"hit_effect": preload("res://VFX/hit_effect.tscn"),
}


func _ready():
	Events.spawn_effect.connect(_on_spawn_effect)
	Events.spawn_effect_rotated.connect(_on_spawn_effect_rotated)
	Events.frame_freeze.connect(_on_frame_freeze)


func _on_spawn_effect(effect_name: String, effect_position: Vector2):
	_on_spawn_effect_rotated(effect_name, effect_position, 0.0)


func _on_spawn_effect_rotated(effect_name: String, effect_position: Vector2, degree: float):
	if not effect_name in _effects:
		printerr("invalid effect name: %s" % effect_name)
		return

	var effect = _effects[effect_name].instantiate() as GPUParticles2D
	effect.global_position = effect_position
	effect.rotation_degrees = degree

	add_child(effect)

	await get_tree().create_timer(effect.lifetime).timeout

	effect.queue_free()


func _on_frame_freeze() -> void:
	OS.delay_msec(33)  # 30 fps
