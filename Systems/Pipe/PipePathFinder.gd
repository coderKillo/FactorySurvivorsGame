class_name PipePathFinder
extends Node2D


func find_path(start: Vector2, end: Vector2) -> PackedVector2Array:
	var points = []
	var direction = end - start
	direction.x = clamp(direction.x, -1, 1)
	direction.y = clamp(direction.y, -1, 1)

	var point = start

	for x in _range_inclusive(int(start.x), int(end.x), int(direction.x)):
		point.x = x
		points.append(point)

	for y in _range_inclusive(int(start.y + direction.y), int(end.y), int(direction.y)):
		point.y = y
		points.append(point)

	return points


func _range_inclusive(start: int, end: int, direction: int) -> Array:
	return range(start, end + direction, direction if direction != 0 else 1)
