class_name ModelComponent
extends Node2D

signal animation_finished
signal animation_looped

var animation: String = "":
	get = _get_animation
var flip_h: bool = false:
	set = _set_flip_h

var _parts: Array[AnimatedSprite2D]


func add_part(anim: AnimatedSprite2D) -> void:
	if _parts.is_empty():
		anim.animation_finished.connect(_on_animation_finished)
		anim.animation_looped.connect(_on_animation_looped)

	_parts.append(anim)
	add_child(anim)


func play(anim_name: String) -> void:
	for part in _parts:
		part.play(anim_name)


func _on_animation_finished():
	animation_finished.emit()


func _on_animation_looped():
	animation_looped.emit()


func _set_flip_h(value):
	for part in _parts:
		part.flip_h = value


func _get_animation() -> String:
	for part in _parts:
		return part.animation
	return ""
