class_name BlueprintEntity
extends Node2D

signal stack_count_changed(count: int)

@export var entity_name: String = ""
@export var placeable := true
@export var rotateable := false
@export var stack_size := 10
@export var value := 10
@export var cooldown := 2.0
@export var energy_cost := 0

@export var speed := 1.0
@export var damage := 1.0

var stack_count := 1:
	set = _set_stack_count


func empty() -> bool:
	return stack_count <= 0


func full() -> bool:
	return stack_count >= stack_size


func _set_stack_count(v):
	stack_count = v
	stack_count_changed.emit(v)
