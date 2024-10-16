class_name Blaster
extends Weapon

@export var projectile_container: Node2D

@onready var _shoot_position: Marker2D = $Marker2D
@onready var _sprite: Sprite2D = $Sprite2D


func _fire():
	fire_rate = UpgradeData.blaster_data.fire_rate

	var projectile: Projectile = UpgradeData.blaster_data.ProjectileScene.instantiate()
	projectile.transform = _shoot_position.global_transform
	projectile.top_level = true
	projectile.damage = UpgradeData.blaster_data.damage
	projectile.has_screenshake = true
	projectile.scale = Vector2(
		UpgradeData.blaster_data.projectile_scale, UpgradeData.blaster_data.projectile_scale
	)

	projectile_container.add_child(projectile)

	energy_used.emit(projectile.cost - UpgradeData.blaster_data.cost_reduction)

	SoundManager.play("blaster_fire")


func _update_weapon_direction():
	_sprite.flip_v = not is_right
