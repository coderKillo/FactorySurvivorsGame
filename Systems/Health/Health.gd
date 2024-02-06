class_name Health
extends Node2D

signal take_damage(amount, health)
signal death

@export var max_health = 30

var _points = 0


func _ready():
	_points = max_health


func damage(amount: int):
	_points = max(0, _points - amount)
	take_damage.emit(amount, _points)

	if _points <= 0:
		death.emit()
