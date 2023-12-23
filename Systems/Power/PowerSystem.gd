class_name PowerSystem
extends RefCounted

var power_receivers = {}
var power_sources = {}
var power_movers = {}

var paths = []
var cell_travelled = []
var receivers_already_provided = {}


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

	if power_receivers.remove(cellv):
		retrace = true

	if power_sources.remove(cellv):
		retrace = true

	if power_movers.remove(cellv):
		retrace = true

	if retrace:
		_retrace_paths()


func _on_system_tick(_delta):
	pass


func _retrace_paths():
	pass
