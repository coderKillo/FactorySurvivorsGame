extends Entity

var slot := InventorySlot.new()

@onready var _heat_provider: HeatProvider = $HeatProvider
@onready var _fire: AnimatedSprite2D = $FireAnimation


func _ready():
	Events.system_tick.connect(_on_system_tick)


func _on_material_enter_area_body_entered(body: Node2D):
	if not body.is_in_group("ore"):
		return

	var entity := body as GroundEntity
	if not entity:
		return

	slot.stack += 1


func _on_system_tick(_delta):
	if _heat_provider.amount <= 0 and not slot.empty():
		slot.stack -= 1
		_heat_provider.amount = value

	if _heat_provider.amount > 0:
		_fire.show()
	else:
		_fire.hide()
