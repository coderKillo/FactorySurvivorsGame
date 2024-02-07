class_name HurtBoxComponent
extends Area2D

@export var health: Health

var can_take_damage = true


func _ready() -> void:
	assert(health, "missing health component")


func take_damage(damage: int):
	if not can_take_damage:
		return

	health.points -= damage
