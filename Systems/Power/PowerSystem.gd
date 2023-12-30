class_name PowerSystem
extends RefCounted

var power_receivers = {}
var power_sources = {}
var power_movers = {}

var networks = []

const NETWORK_SOURCES = 0
const NETWORK_RECEIVERS = 1


func _init():
	Events.entity_placed.connect(_on_entity_placed)
	Events.entity_removed.connect(_on_entity_removed)
	Events.system_tick.connect(_on_system_tick)


func _on_entity_placed(entity: Entity, cellv: Vector2):
	var retrace = false

	if entity.is_in_group(Types.POWER_RECEIVERS):
		power_receivers[cellv] = entity.get_node_or_null("PowerReceiver")
		retrace = true

	if entity.is_in_group(Types.POWER_SOURCES):
		power_sources[cellv] = entity.get_node_or_null("PowerSource")
		retrace = true

	if entity.is_in_group(Types.POWER_MOVERS):
		power_movers[cellv] = entity.get_node_or_null("PowerMover")
		retrace = true

	if retrace:
		_retrace_paths()


func _on_entity_removed(_entity: Entity, cellv: Vector2):
	var retrace = false

	if power_receivers.erase(cellv):
		retrace = true

	if power_sources.erase(cellv):
		retrace = true

	if power_movers.erase(cellv):
		retrace = true

	if retrace:
		_retrace_paths()


func _on_system_tick(delta):
	for network in networks:
		var power_available = 0

		for pos in network[NETWORK_SOURCES]:
			if not pos in power_sources:
				continue

			var source: PowerSource = power_sources[pos]

			power_available += source.get_effective_power()

		for pos in network[NETWORK_RECEIVERS]:
			if not pos in power_receivers:
				continue

			var receiver: PowerReceiver = power_receivers[pos]
			var power_provided = min(receiver.power_required, power_available)

			receiver.received_power.emit(power_provided, delta)
			power_available -= power_provided

			if power_available <= 0:
				break


func _retrace_paths():
	networks.clear()

	var cell_travelled = []

	for source in power_sources.keys():
		if source in cell_travelled:
			continue

		var network = [[], []]
		var cell_queue = [source]
		cell_travelled.append(source)

		while not cell_queue.is_empty():
			var cell = cell_queue.pop_front()

			if cell in power_sources:
				network[NETWORK_SOURCES].append(cell)
			if cell in power_receivers:
				network[NETWORK_RECEIVERS].append(cell)

			for direction in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
				var neighbor = cell + direction
				if neighbor in cell_travelled:
					continue

				if (
					(not neighbor in power_sources)
					and (not neighbor in power_receivers)
					and (not neighbor in power_movers)
				):
					continue

				cell_travelled.append(neighbor)
				cell_queue.push_back(neighbor)

		networks.append(network)
