class_name WeaponUgrade
extends Upgrade

@export var damage := 0
@export var fire_rate := 0.0
@export var ProjectileScene: PackedScene


func upgrade(weapon: Weapon):
	weapon.fire_rate -= fire_rate
	weapon.fire_rate = max(0.05, weapon.fire_rate)
	weapon.damage += damage

	if ProjectileScene != null:
		var blaster = weapon as Blaster
		blaster.ProjectileScene = ProjectileScene
