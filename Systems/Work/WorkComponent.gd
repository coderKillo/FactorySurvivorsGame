class_name WorkComponent
extends Node2D

const INPUT_SLOT = 0
const OUTPUT_SLOT = 1

signal update_progress(percent: float)
signal add_inventory_item(slot: int)
signal remove_inventory_item(slot: int)

@export var input_name := ""
@export var output_name := ""
@export var process_time := 2
@export var pickup_time := 1
@export var pickup_area: Area2D
@export var output_pos: Marker2D

# blueprint to ceep track of stack size
var _blueprints: Array[BlueprintEntity] = []

@onready var _process_timer: Timer = $ProcessTimer
@onready var _pickup_timer: Timer = $PickUpTimer


func _ready():
	assert(input_name in Library.blueprints, "invalid input")
	assert(output_name in Library.entites, "invalid output")

	_process_timer.timeout.connect(_on_process_timer_timeout)
	_pickup_timer.timeout.connect(_on_pickup_timer_timeout)
	_pickup_timer.timeout.connect(_on_place_timer_timeout)
	_pickup_timer.start(pickup_time)

	_blueprints = [
		Library.blueprints[input_name].instantiate(), Library.blueprints[output_name].instantiate()
	]

	_blueprints[INPUT_SLOT].stack_count = 0
	_blueprints[OUTPUT_SLOT].stack_count = 0


func _process(_delta):
	if not _process_timer.is_stopped():
		update_progress.emit(process_time / _process_timer.time_left)


func start() -> void:
	if !_process_timer.is_stopped():
		return
	_process_timer.start(process_time)
	update_progress.emit(0.0)


func stop() -> void:
	_process_timer.stop()
	update_progress.emit(0.0)


func has_available_work() -> bool:
	return _blueprints[INPUT_SLOT].stack_count > 0


func _on_pickup_timer_timeout() -> void:
	var entity := _get_valid_input_entity()
	if entity == null:
		return

	if _blueprints[INPUT_SLOT].full():
		return

	_add_item(INPUT_SLOT)
	entity.queue_free()


func _on_place_timer_timeout() -> void:
	if _blueprints[OUTPUT_SLOT].empty():
		return

	_remove_item(OUTPUT_SLOT)
	Events.ground_entity_spawn.emit(output_name, output_pos.global_position)


func _on_process_timer_timeout() -> void:
	if _blueprints[INPUT_SLOT].empty() or _blueprints[OUTPUT_SLOT].full():
		return

	_remove_item(INPUT_SLOT)
	_add_item(OUTPUT_SLOT)


func _get_valid_input_entity() -> Entity:
	for body in pickup_area.get_overlapping_bodies():
		var entitiy_name = Library.get_entity_name(body)
		if entitiy_name == input_name:
			return body

	return null


func _add_item(slot: int) -> void:
	_blueprints[slot].stack_count += 1
	add_inventory_item.emit(slot)


func _remove_item(slot: int) -> void:
	_blueprints[slot].stack_count -= 1
	remove_inventory_item.emit(slot)
