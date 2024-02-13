class_name Energy
extends Node2D

signal update_energy(amount, max_value)
signal charge_status_changed(is_charging)

@export var max_energy := 100
@export var energy_low_trashold := 20
@export var charge_amount := 2

@onready var energy := 0:
	set = _set_energy
@onready var _area: Area2D = $Area2D

var _source: PowerSource = null


func _ready():
	energy = max_energy
	_area.body_entered.connect(_on_body_entered)
	_area.body_exited.connect(_on_body_exited)
	Events.system_tick.connect(_on_system_tick)


func is_charging() -> bool:
	return _source != null


func charge_is_low() -> bool:
	return energy <= energy_low_trashold


func _set_energy(value):
	energy = value
	update_energy.emit(energy, max_energy)


func _on_body_entered(body: PhysicsBody2D):
	if not body.is_in_group(Types.POWER_SOURCES):
		return

	if _source != null:
		return

	_source = body.get_node_or_null("PowerSource")
	if _source.power_amount < charge_amount:
		_source = null
		return

	_source.power_amount -= charge_amount
	charge_status_changed.emit(true)


func _on_body_exited(body: PhysicsBody2D):
	if not body.is_in_group(Types.POWER_SOURCES):
		return

	var source = body.get_node_or_null("PowerSource")
	if source == _source:
		_source.power_amount += charge_amount
		_source = null
		charge_status_changed.emit(false)


func _on_system_tick(_delta):
	if not is_charging():
		return

	energy = clamp(energy + charge_amount, 0, max_energy)
