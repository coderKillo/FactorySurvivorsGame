extends Node

var _effects = {"upgrade_explosion": preload("res://VFX/upgrade_explosion.tscn")}


func _ready():
	Events.spawn_effect.connect(_on_spawn_effect)


func _on_spawn_effect(effect_name: String, effect_position: Vector2):
	if not effect_name in _effects:
		printerr("invalid effect name: %s" % effect_name)
		return

	var effect = _effects[effect_name].instantiate() as GPUParticles2D
	effect.global_position = effect_position

	add_child(effect)

	await get_tree().create_timer(effect.lifetime).timeout

	effect.queue_free()
