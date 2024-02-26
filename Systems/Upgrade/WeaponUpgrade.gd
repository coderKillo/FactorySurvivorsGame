class_name WeaponUgrade
extends Upgrade

@export var damage := 0.0
@export var fire_rate := 0.0


func upgrade(weapon: Weapon):
	weapon.fire_rate *= (1.0 - fire_rate)
	weapon.damage = int(weapon.damage * (1.0 + damage))
