class_name PowerSystem
extends RefCounted

var power_receivers = {}
var power_sources = {}

var _total_power := 0


func _init():
	Events.entity_placed.connect(_on_entity_placed)
	Events.entity_removed.connect(_on_entity_removed)
	Events.system_tick.connect(_on_system_tick)


func total_power() -> int:
	return _total_power


func _on_entity_placed(entity: Entity, cellv: Vector2):
	if entity.is_in_group(Types.POWER_RECEIVERS):
		power_receivers[cellv] = entity.get_node_or_null("PowerReceiver")

	if entity.is_in_group(Types.POWER_SOURCES):
		power_sources[cellv] = entity.get_node_or_null("PowerSource")


func _on_entity_removed(_entity: Entity, cellv: Vector2):
	power_receivers.erase(cellv)
	power_sources.erase(cellv)


func _on_system_tick(delta):
	var power_produced := 0
	var power_used := 0

	var power_available = 0

	for source in power_sources.values():
		power_available += source.get_effective_power()

	var network_power = power_available

	for receiver in power_receivers.values():
		var power_provided = min(receiver.power_required, power_available)

		receiver.received_power.emit(power_provided, delta)
		power_available -= power_provided

	var network_utilization = (1 - (power_available / network_power)) if network_power > 0 else 0

	for source in power_sources.values():
		source.utilization = network_utilization
		source.power_updated.emit(source.get_effective_power(), delta)

	_total_power += network_power
	power_produced += network_power
	power_used += network_power - power_available

	Events.power_produced.emit(_total_power, power_produced, power_used)

	var money_produced = network_power
	Events.money_changed.emit(money_produced)
