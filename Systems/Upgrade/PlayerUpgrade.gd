class_name PlayerUpgrade
extends Upgrade


func upgrade(player: Player):
	for u in upgrades:
		u.apply(player)
