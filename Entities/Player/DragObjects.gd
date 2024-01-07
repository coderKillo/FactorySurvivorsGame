class_name DragObjects
extends Area2D

@export var max_distance = 9

var _bodies = []


func grab():
	_bodies = get_overlapping_bodies()


func release():
	_bodies.clear()


func bodies_grabed() -> int:
	return len(_bodies)


func _draw():
	for body in _bodies:
		draw_line(global_position, body.global_position, Color.BLACK, 1.0)


func _physics_process(_delta):
	for body in _bodies:
		var distance = body.global_position.distance_to(global_position)
		var direction = body.global_position.direction_to(global_position)

		if distance < max_distance:
			continue

		body.global_position += direction * (distance - max_distance)
