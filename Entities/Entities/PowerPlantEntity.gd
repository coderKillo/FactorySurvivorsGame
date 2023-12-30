extends Entity

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _power_source: PowerSource = $PowerSource
@onready var _heat_receiver: HeatReceiver = $HeatReceiver

var _active: bool = false


func _ready():
	_heat_receiver.matieral_provided.connect(_on_heat_provided)
	_set_active(_active)


func _on_heat_provided(amount):
	_power_source.efficency = amount / _heat_receiver.required_heat

	if _power_source.efficency > 0.0 and not _active:
		_set_active(true)
	if _power_source.efficency == 0.0 and _active:
		_set_active(false)


func _set_active(active: bool):
	if active:
		_animation.play("active")
	else:
		_animation.play("idle")

	_active = active
