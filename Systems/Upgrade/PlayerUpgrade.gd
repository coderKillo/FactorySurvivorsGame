class_name PlayerUpgrade
extends Upgrade

@export var health := 0
@export var energy := 0
@export var speed := 0.0


func upgrade(player: Player):
	player.health.max_health += health
	player.energy.max_energy += energy
	player.movement_speed += speed
