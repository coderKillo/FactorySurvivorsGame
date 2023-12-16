class_name PowerSource
extends Node2D

signal power_updated(amount, delta)

export var power_amount = 10.0

var efficency = 0.0

func get_effective_power() -> flaot:
    return power_amount * efficency