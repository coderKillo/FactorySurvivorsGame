class_name Blaster
extends Weapon

@export var Projectile = preload("res://Systems/Weapon/Projectile.tscn")

@onready var _shoot_position: Marker2D = $Marker2D
@onready var _sprite: Sprite2D = $Sprite2D


func _fire():
	var projectile: = Projectile.instantiate()
	projectile.transform = _shoot_position.global_transform
	projectile.top_level = true
	projectile.damage = damage

	add_child(projectile)
	projectile.owner = owner

	_on_cooldown = true
	_cooldown_timer.start(fire_rate)


func _update_weapon_direction():
	_sprite.flip_v = not is_right
