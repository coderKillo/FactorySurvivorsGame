extends Entity

@onready var _heat_provider: HeatProvider = $HeatProvider
@onready var _fire: AnimatedSprite2D = $FireAnimation


func _ready():
	Events.system_tick.connect(_on_system_tick)


func _process(_delta):
	_heat_provider.amount = 100


func _on_material_enter_area_body_entered(body: Node2D):
	if body.is_in_group("enemy"):
		body.queue_free()

	if body.is_in_group("ore"):
		body.queue_free()


func _on_system_tick(_delta):
	if _heat_provider.amount > 0:
		_fire.show()
	else:
		_fire.hide()
