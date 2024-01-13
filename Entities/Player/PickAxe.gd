class_name PickAxe
extends Weapon

@onready var _damage_zone: Area2D = $Area2D
@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D


func _fire():
	_animation.play("attack")

	for body in _damage_zone.get_overlapping_bodies():
		var health: Health = body.get_node_or_null("Health")
		if health != null:
			health.damage(damage)


func _update_weapon_direction():
	_animation.flip_v = not is_right
	_damage_zone.scale.x = 1 if is_right else -1
