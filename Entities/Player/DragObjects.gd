class_name DragObjects
extends Area2D

@export var max_distance = 9

var _bodies = []
var _grab = false


func grab():
	_grab = true


func release():
	_grab = false


func bodies_grabed() -> int:
	return len(_bodies)


func _draw():
	if not _grab:
		return

	for body in get_overlapping_bodies():
		draw_line(global_position, body.global_position, Color.BLACK, 1.0)


func _physics_process(_delta):
	if not _grab:
		return

	for body in get_overlapping_bodies():
		var distance = body.global_position.distance_to(global_position)
		var direction = body.global_position.direction_to(global_position)
		var entity := body as GroundEntity

		if not entity.is_draggable:
			continue

		if distance < max_distance:
			continue

		body.global_position += direction * (distance - max_distance)
