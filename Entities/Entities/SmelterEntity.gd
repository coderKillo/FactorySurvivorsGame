extends Entity

@onready var _heat_provider: HeatProvider = $HeatProvider


func _process(delta):
	_heat_provider.amount = 100
