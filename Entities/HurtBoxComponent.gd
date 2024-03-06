class_name HurtBoxComponent
extends Area2D

@export var health: Health
@export var hit_sound := ""

var can_take_damage = true


func _ready() -> void:
	assert(health, "missing health component")


func take_damage(damage: int):
	if not can_take_damage:
		return

	if hit_sound != "":
		SoundManager.play(hit_sound)

	health.points -= damage
