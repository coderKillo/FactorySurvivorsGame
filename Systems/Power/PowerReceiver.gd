# This receives power and stores it
class_name PowerReceiver
extends Node2D

signal received_power(amount, delta)

@export var power_required = 10.0
@export var power_limit = 20.0

var efficency = 0.0
var _power_stored := 0.0


func _ready():
	received_power.connect(_on_received_power)


func get_effective_power() -> float:
	return power_required * efficency


func consume_power() -> bool:
	if _power_stored >= power_required:
		_power_stored -= power_required
		return true

	return false


func is_battery_low() -> bool:
	return _power_stored <= power_required


func _on_received_power(amount, _delta) -> void:
	_power_stored += amount
	_power_stored = clamp(_power_stored, 0, power_limit)
	print(_power_stored)
