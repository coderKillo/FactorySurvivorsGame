class_name BlueprintEntity
extends Node2D

signal stack_count_changed(count: int)

@export var entity_name: String = ""
@export var placeable := true
@export var rotateable := false
@export var on_cooldown := false

@export var data := EntityData.new()

var stack_count := 1:
	set = _set_stack_count


func empty() -> bool:
	return stack_count <= 0


func full() -> bool:
	return stack_count >= data.stack_size


func _set_stack_count(v):
	stack_count = v
	stack_count_changed.emit(v)
