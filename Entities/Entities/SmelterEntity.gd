extends Entity

@onready var _heat_provider: HeatProvider = $HeatProvider


func _process(_delta):
	_heat_provider.amount = 100


func _on_material_enter_area_body_entered(body: Node2D):
	body.queue_free()
