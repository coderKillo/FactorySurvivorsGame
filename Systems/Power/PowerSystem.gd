class_name PowerSystem
extends RefCounted

var power_receivers = {}
var power_sources = {}
var power_movers = {}

var networks = []

const NETWORK_SOURCES = 0
const NETWORK_RECEIVERS = 1

var _total_power := 0
var _current_power_level := 0
var _total_power_level := 10000


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
		power_movers[cellv] = entity
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
	var power_produced := 0
	var power_used := 0

	for network in networks:
		var power_available = 0

		for pos in network[NETWORK_SOURCES]:
			if not pos in power_sources:
				continue

			var source: PowerSource = power_sources[pos]

			power_available += source.get_effective_power()

		var network_power = power_available

		for pos in network[NETWORK_RECEIVERS]:
			if not pos in power_receivers:
				continue

			var receiver: PowerReceiver = power_receivers[pos]
			var power_provided = min(receiver.power_required, power_available)

			receiver.received_power.emit(power_provided, delta)
			power_available -= power_provided

		var network_utilization = (
			(1 - (power_available / network_power)) if network_power > 0 else 0
		)

		for pos in network[NETWORK_SOURCES]:
			if not pos in power_sources:
				continue

			var source: PowerSource = power_sources[pos]
			source.utilization = network_utilization
			source.power_updated.emit(source.get_effective_power(), delta)

		_total_power += network_power
		_current_power_level += network_power
		power_produced += network_power
		power_used += network_power - power_available

	if _current_power_level >= _total_power_level:
		_current_power_level -= _total_power_level
		Events.leveled_up.emit()

	Events.power_produced.emit(_total_power, power_produced, power_used)
	Events.power_level_changed.emit(_current_power_level, _total_power_level)


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

			if cell in power_receivers:
				# power receivers are endpoints, so no futher search
				network[NETWORK_RECEIVERS].append(cell)

			if cell in power_sources:
				# power sources are startpoints, so only search for movers
				network[NETWORK_SOURCES].append(cell)

				for direction in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
					var neighbor = cell + direction

					if neighbor in cell_travelled:
						continue
					if neighbor not in power_movers:
						continue

					cell_queue.push_back(neighbor)
					cell_travelled.append(neighbor)

			if cell in power_movers:
				# power movers subscribe to neighbor sources / receivers
				for direction in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
					var neighbor = cell + direction

					if neighbor in power_sources:
						var power: PowerSource = power_sources[neighbor]
						var wire: WireEntity = power_movers[cell]
						power.power_updated.connect(wire._on_power_input.bind(direction))

					elif neighbor in power_receivers:
						var receiver: PowerReceiver = power_receivers[neighbor]
						var wire: WireEntity = power_movers[cell]
						receiver.received_power.connect(wire._on_power_output.bind(direction))

					if neighbor in cell_travelled:
						continue

					cell_queue.push_back(neighbor)
					cell_travelled.append(neighbor)

		networks.append(network)
