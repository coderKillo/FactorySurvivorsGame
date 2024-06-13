class_name PipePathFinder
extends Node2D

var _astar := AStar2D.new()
var _tilemap: TileMap
var _entity_tracker: EntityTracker

var _area := Rect2()


func _ready():
	Events.entity_placed.connect(_on_entity_placed)


func setup(tilemap: TileMap, entity_tracker: EntityTracker) -> void:
	_tilemap = tilemap
	_entity_tracker = entity_tracker


func find_path(start: Vector2, end: Vector2) -> PackedVector2Array:
	var start_id := _get_index(start)
	var end_id := _get_index(end)

	if not _area_has_point(start) or not _area_has_point(end):
		return PackedVector2Array()

	if not _astar.has_point(start_id) or not _astar.has_point(end_id):
		return PackedVector2Array()

	return _astar.get_point_path(start_id, end_id)


func _on_entity_placed(_entity: Entity, cellv: Vector2):
	var new_area = _area.expand(cellv)
	if new_area != _area:
		_area = new_area
		_update_points()


func _update_points() -> void:
	_astar.clear()

	var points = _create_points_from_area()

	for point in points:
		var index := _get_index(point)
		var weight := 1.0

		# if _entity_tracker.entities.has(point):
		# 	weight = 0.0

		# TODO: increase weight if vector is pipe / ask tilemap

		_astar.add_point(index, point, weight)

	for point in points:
		for neighbor in _get_neighbor(point):
			_astar.connect_points(_get_index(point), _get_index(neighbor))


func _get_neighbor(point: Vector2) -> Array:
	var neighbors := []
	for direction in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
		var neighbor = point + direction
		if _astar.has_point(_get_index(neighbor)) and _area_has_point(neighbor):
			neighbors.append(neighbor)
	return neighbors


func _create_points_from_area() -> Array:
	var points := []
	for x in range(_area.position.x, _area.end.x + 1):
		for y in range(_area.position.y, _area.end.y + 1):
			points.append(Vector2(x, y))
	return points


func _get_index(vector: Vector2) -> int:
	return int((vector.x - _area.position.x) + (_area.size.x + 1) * (vector.y - _area.position.y))


func _area_has_point(point: Vector2) -> bool:
	if point.x < _area.position.x or point.x > _area.end.x:
		return false
	if point.y < _area.position.y or point.y > _area.end.y:
		return false
	return true
