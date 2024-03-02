class_name Health
extends Node2D

signal update_health(health)
signal death

@export var max_health = 30:
	set = _set_max_health

var points = 0:
	set = _set_health_points


func _ready():
	points = max_health


func _set_max_health(value: int):
	var current_health_percent: float = points / float(max_health)
	max_health = value
	points = current_health_percent * max_health


func _set_health_points(value: int):
	points = clampi(value, 0, max_health)
	update_health.emit(points)

	if points <= 0:
		death.emit()
