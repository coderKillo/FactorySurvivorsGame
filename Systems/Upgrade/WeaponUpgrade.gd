class_name WeaponUgrade
extends Upgrade


func upgrade(weapon: Weapon):
	for u in upgrades:
		u.apply(weapon)
