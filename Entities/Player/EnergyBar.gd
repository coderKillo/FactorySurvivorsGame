extends ProgressBar

@export var _energy: Energy


func _ready():
	_energy.update_energy.connect(_on_update_energy)
	_on_update_energy(_energy.max_energy, _energy.max_energy)


func _on_update_energy(amount, max_amount):
	max_value = max_amount
	value = amount

	if amount < max_amount:
		show()
	else:
		hide()
