class_name PickAxe
extends Weapon

@onready var _damage_zone: Area2D = $Area2D
@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D


func _fire():
	_animation.play("attack")

	await get_tree().create_timer(0.2).timeout

	for body in _damage_zone.get_overlapping_bodies():
		var health: Health = body.get_node_or_null("Health")
		if health != null:
			health.damage(damage)

		var destruction: DestructionComponent = body.get_node_or_null("DestructionComponent")
		if destruction != null and destruction.destruction_filter == type:
			destruction.destruct()


func _update_weapon_direction():
	_animation.flip_v = not is_right
