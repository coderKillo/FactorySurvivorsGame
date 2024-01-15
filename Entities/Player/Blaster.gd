class_name Blaster
extends Weapon

@export var ProjectileScene = preload("res://Systems/Weapon/Projectile.tscn")
@export var projectile_container: Node2D

@onready var _shoot_position: Marker2D = $Marker2D
@onready var _sprite: Sprite2D = $Sprite2D


func _fire():
	var projectile: Projectile = ProjectileScene.instantiate()
	projectile.transform = _shoot_position.global_transform
	projectile.top_level = true
	projectile.damage = damage

	projectile_container.add_child(projectile)

	energy_used.emit(projectile.cost)

	_on_cooldown = true
	_cooldown_timer.start(fire_rate)


func _update_weapon_direction():
	_sprite.flip_v = not is_right
