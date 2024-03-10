class_name DragObjects
extends Area2D

@export var max_distance = 9
@export var max_bodies = 1

var _grab = false


func grab():
	_grab = true


func release():
	_grab = false


func bodies_grabed() -> int:
	return len(get_bodies())


func _draw():
	for body in get_bodies():
		draw_line(global_position, body.global_position, Color.BLACK, 1.0)


func _physics_process(_delta):
	for body in get_bodies():
		var distance = body.global_position.distance_to(global_position)
		var direction = body.global_position.direction_to(global_position)
		var entity := body as GroundEntity

		if not entity.is_draggable:
			continue

		if distance < max_distance:
			continue

		body.global_position += direction * (distance - max_distance)


func get_bodies() -> Array:
	var bodies = []
	if not _grab:
		return bodies

	for body in get_overlapping_bodies():
		bodies.append(body)
		if len(bodies) >= max_bodies:
			break

	return bodies
