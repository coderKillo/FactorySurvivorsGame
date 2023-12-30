class_name MiningSystem
extends RefCounted

var material_receivers = {}
var material_providers = {}


func _init():
	Events.entity_placed.connect(_on_entity_placed)
	Events.entity_removed.connect(_on_entity_removed)
	Events.system_tick.connect(_on_system_tick)


func _on_entity_placed(entity: Entity, cellv: Vector2):
	if entity.is_in_group(Types.MATERIAL_PROVIDER):
		material_providers[cellv] = entity.get_node_or_null("MaterialProvider")

	if entity.is_in_group(Types.MATERIAL_RECEIVER):
		material_receivers[cellv] = entity.get_node_or_null("MaterialReceiver")


func _on_entity_removed(_entity: Entity, cellv: Vector2):
	material_providers.erase(cellv)
	material_receivers.erase(cellv)


func _on_system_tick(_delta):
	for provider in material_providers:
		var receivers = _get_neighbor_receivers(provider)
		var material_used = 0
		var material_total = material_providers[provider].amount

		for pos in receivers:
			var receiver: MaterialReceiver = material_receivers[pos]
			var material_provided = min(receiver.required_material, material_total / len(receivers))
			material_used += material_provided
			receiver.matieral_provided.emit(material_provided)

		material_providers[provider].amount -= material_used


func _get_neighbor_receivers(provider: Vector2) -> Array:
	var receivers := Array()

	for i in range(-1, 2):
		for j in range(-1, 2):
			if i == 0 and j == 0:
				continue

			var neighbor: Vector2 = provider + Vector2(i, j)
			if neighbor not in material_receivers:
				continue

			receivers.append(neighbor)

	return receivers
