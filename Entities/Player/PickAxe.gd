class_name PickAxe
extends Weapon

@onready var _damage_zone: Area2D = $Area2D
@onready var _damage_effect: Sprite2D = $Sprite2D
@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D


func _fire():
	_animation.speed_scale = fire_rate
	_animation.play("attack")

	await get_tree().create_timer(0.2 * fire_rate).timeout

	_create_slash_effect()

	SoundManager.play("pickaxe_hit")

	for body in _damage_zone.get_overlapping_bodies():
		var destruction := body.get_node_or_null("DestructionComponent") as DestructionComponent
		if destruction != null and destruction.destruction_filter == type:
			destruction.destruct()

	for area in _damage_zone.get_overlapping_areas():
		var hurt_box = area as HurtBoxComponent
		if hurt_box != null:
			hurt_box.take_damage(damage)


func _create_slash_effect() -> void:
	var tween = get_tree().create_tween()

	tween.tween_callback(_damage_effect.show)
	tween.tween_property(
		_damage_effect, "global_position", _damage_effect.global_position, 0.3 * fire_rate
	)
	tween.tween_property(_damage_effect, "position", Vector2.ZERO, 0.01)
	tween.tween_callback(_damage_effect.hide)


func _update_weapon_direction():
	_animation.flip_v = not is_right
