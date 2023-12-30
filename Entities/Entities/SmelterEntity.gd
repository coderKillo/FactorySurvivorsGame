extends Entity

@onready var _material_provider: MaterialProvider = $MaterialProvider


func _process(delta):
	_material_provider.amount = 100
