class_name MiningSystem
extends RefCounted

var heat_receivers = {}
var heat_providers = {}


func _init():
	Events.entity_placed.connect(_on_entity_placed)
	Events.entity_removed.connect(_on_entity_removed)
	Events.system_tick.connect(_on_system_tick)


func _on_entity_placed(entity: Entity, cellv: Vector2):
	if entity.is_in_group(Types.HEAT_PROVIDER):
		heat_providers[cellv] = entity.get_node_or_null("HeatProvider")

	if entity.is_in_group(Types.HEAT_RECEIVER):
		heat_receivers[cellv] = entity.get_node_or_null("HeatReceiver")


func _on_entity_removed(_entity: Entity, cellv: Vector2):
	heat_providers.erase(cellv)
	heat_receivers.erase(cellv)


func _on_system_tick(_delta):
	for provider in heat_providers:
		var receivers = _get_neighbor_receivers(provider)
		var heat_used = 0
		var heat_total = heat_providers[provider].amount

		for pos in receivers:
			var receiver: HeatReceiver = heat_receivers[pos]
			var heat_provided = min(receiver.required_heat, heat_total / len(receivers))
			heat_used += heat_provided
			receiver.matieral_provided.emit(heat_provided)

		heat_providers[provider].amount -= heat_used


func _get_neighbor_receivers(provider: Vector2) -> Array:
	var receivers := Array()

	for i in range(-1, 2):
		for j in range(-1, 2):
			if i == 0 and j == 0:
				continue

			var neighbor: Vector2 = provider + Vector2(i, j)
			if neighbor not in heat_receivers:
				continue

			receivers.append(neighbor)

	return receivers
