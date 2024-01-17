class_name WorkComponent
extends Node2D

@export var input_name := ""
@export var output_name := ""
@export var process_time := 2
@export var pickup_time := 1
@export var pickup_area: Area2D
@export var output_pos: Marker2D

var is_processing = false

@onready var _process_timer: Timer = $ProcessTimer
@onready var _pickup_timer: Timer = $PickUpTimer
@onready var _input_panel: InventoryPanel = $GUI/VBoxContainer/HBoxContainer/InputPanel
@onready var _output_panel: InventoryPanel = $GUI/VBoxContainer/HBoxContainer/OutputPanel


func _ready():
	assert(input_name in Library.entites, "invalid input")
	assert(output_name in Library.blueprints, "invalid output")
	assert(pickup_area == null, "please set a pickup area")
	assert(output_pos == null, "please set a output pos")

	_process_timer.timeout.connect(_on_process_timer_timeout)
	_pickup_timer.timeout.connect(_on_pickup_timer_timeout)
	_pickup_timer.start(pickup_time)


func start() -> void:
	if !_process_timer.is_stopped():
		return
	_process_timer.start(process_time)


func stop() -> void:
	_process_timer.stop()


func is_item_in_pickup_area() -> bool:
	return pickup_area.has_overlapping_bodies()


func _on_pickup_timer_timeout() -> void:
	if not is_item_in_pickup_area():
		return

	var item = pickup_area.get_overlapping_bodies().front()


func _on_process_timer_timeout() -> void:
	pass
