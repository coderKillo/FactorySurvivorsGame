class_name WorkComponent
extends Node2D

@export var input_name := ""
@export var output_name := ""
@export var process_time := 2
@export var pickup_time := 1
@export var pickup_area: Area2D
@export var output_pos: Marker2D

@onready var _process_timer: Timer = $ProcessTimer
@onready var _pickup_timer: Timer = $PickUpTimer
@onready var _input_panel: InventoryPanel = $GUI/VBoxContainer/HBoxContainer/InputPanel
@onready var _output_panel: InventoryPanel = $GUI/VBoxContainer/HBoxContainer/OutputPanel
@onready var _progress_bar: ProgressBar = $GUI/VBoxContainer/ProgressBar
@onready var _gui: Control = $GUI


func _ready():
	assert(input_name in Library.blueprints, "invalid input")
	assert(output_name in Library.entites, "invalid output")

	_process_timer.timeout.connect(_on_process_timer_timeout)
	_pickup_timer.timeout.connect(_on_pickup_timer_timeout)
	_pickup_timer.timeout.connect(_on_place_timer_timeout)
	_pickup_timer.start(pickup_time)
	_progress_bar.value = 0


func _process(_delta):
	if not _process_timer.is_stopped():
		_progress_bar.value = process_time - _process_timer.time_left


func setup_gui(gui: GUI):
	_input_panel.setup(gui)
	_output_panel.setup(gui)

	_input_panel.item_filter = input_name
	_output_panel.item_filter = output_name


func show_gui():
	_gui.show()


func hide_gui():
	_gui.hide()


func start() -> void:
	if !_process_timer.is_stopped():
		return
	_process_timer.start(process_time)
	_progress_bar.max_value = process_time
	_progress_bar.value = 0


func stop() -> void:
	_process_timer.stop()
	_progress_bar.value = 0


func has_available_work() -> bool:
	return _input_panel.held_item != null


func _on_pickup_timer_timeout() -> void:
	if not pickup_area.has_overlapping_bodies():
		return

	var entity := _get_valid_input_entity()
	if entity == null:
		return

	if _add_blueprint_to_panel(input_name, _input_panel):
		entity.queue_free()


func _on_place_timer_timeout() -> void:
	if _remove_blueprint_from_panel(_output_panel):
		Events.ground_entity_spawn.emit(output_name, output_pos.global_position)


func _on_process_timer_timeout() -> void:
	if _input_panel.held_item == null:
		return

	if _add_blueprint_to_panel(output_name, _output_panel):
		_remove_blueprint_from_panel(_input_panel)


func _get_valid_input_entity() -> Entity:
	for body in pickup_area.get_overlapping_bodies():
		var entitiy_name = Library.get_entity_name(body)
		if entitiy_name == input_name:
			return body

	return null


func _add_blueprint_to_panel(blueprint_name: String, panel: InventoryPanel) -> bool:
	var blueprint = Library.blueprints[blueprint_name].instantiate()

	if panel.held_item == null:
		panel.held_item = blueprint
		return true

	elif panel.held_item.stack_count < panel.held_item.stack_size:
		panel.held_item.stack_count += 1
		blueprint.queue_free()
		return true

	blueprint.queue_free()
	return false


func _remove_blueprint_from_panel(panel: InventoryPanel) -> bool:
	if panel.held_item == null:
		return false

	panel.held_item.stack_count -= 1

	if panel.held_item.stack_count <= 0:
		panel.held_item = null

	return true
