extends Entity

@onready var _heat_provider: HeatProvider = $HeatProvider


func _process(_delta):
	_heat_provider.amount = 100


func _on_material_enter_area_body_entered(body: Node2D):
	if body.is_in_group("enemy"):
		body.queue_free()

	if body.is_in_group("ore"):
		body.queue_free()
