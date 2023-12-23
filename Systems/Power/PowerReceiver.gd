class_name PowerReceiver
extends Node2D

signal received_power(amount, delta)

@export var power_required = 10.0

var efficency = 0.0


func get_effective_power() -> float:
	return power_required * efficency
