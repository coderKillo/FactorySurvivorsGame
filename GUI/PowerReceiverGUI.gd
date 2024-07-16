extends Node

@export var power_receiver: PowerReceiver

@onready var _on: ColorRect = $OnColorRect
@onready var _off: ColorRect = $OffColorRect


func _ready():
	assert(power_receiver)

	power_receiver.received_power.connect(_on_received_power)


func _on_received_power(amount, _delta):
	if amount >= power_receiver.power_required:
		_on.show()
		_off.hide()
	else:
		_on.hide()
		_off.show()
