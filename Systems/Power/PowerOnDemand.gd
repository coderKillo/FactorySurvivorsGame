class_name PowerOnDemand
extends PowerReceiver

## Special power receiver that only draw power when active

## set the required power to zero if not active
## set efficency to the provided power if active else efficency is zero

var _active: bool = false
var _power_on: float = 0
var _power_off: float = 0


func _ready():
	received_power.connect(_on_received_power)

	_power_on = power_required
	power_required = _power_off


func set_active(active: bool):
	_active = active
	power_required = _power_on if _active else _power_off


func _on_received_power(amount, _delta):
	if not _active:
		efficency = 0.0
		return

	efficency = amount / _power_on
