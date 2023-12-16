class_name EntityTracker
extends RefCounted

var entities = {}


func place_entities(entity: Entity, cellv: Vector2):
	if entities.has(cellv):
		return

	entities[cellv] = entity
	_update_power_neighbors(cellv)

	Events.emit_signal("entity_placed", entity, cellv)


func remove_entity(cellv: Vector2):
	if not entities.has(cellv):
		return

	var entity = entities[cellv]
	entities.erase(cellv)
	_update_power_neighbors(cellv)

	Events.emit_signal("entity_removed", entity, cellv)
	entity.queue_free()


func is_cell_occupied(cellv: Vector2) -> bool:
	return entities.has(cellv)


func get_entity_at(cellv: Vector2) -> Entity:
	if entities.has(cellv):
		return entities[cellv]
	else:
		return null


func get_power_neighbors(cellv: Vector2i) -> int:
	var direction: int = 0

	for neighbor in Types.NEIGHBORS:
		var neighbor_cell = cellv + Types.NEIGHBORS[neighbor]

		if not is_cell_occupied(neighbor_cell):
			continue

		var neighbor_entity = get_entity_at(neighbor_cell)

		if (
			neighbor_entity.is_in_group(Types.POWER_MOVERS)
			or neighbor_entity.is_in_group(Types.POWER_RECEIVERS)
			or neighbor_entity.is_in_group(Types.POWER_SOURCES)
		):
			direction |= neighbor

	return direction


func _update_power_neighbors(cellv: Vector2i):
	for neighbor in Types.NEIGHBORS:
		var neighbor_cell = cellv + Types.NEIGHBORS[neighbor]
		var neighbor_entity = get_entity_at(neighbor_cell)

		if neighbor_entity and neighbor_entity is WireEntity:
			WireBlueprint.set_sprite_from_direction(
				neighbor_entity.sprites, get_power_neighbors(neighbor_cell)
			)
