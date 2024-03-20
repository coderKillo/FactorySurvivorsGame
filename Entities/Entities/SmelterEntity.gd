extends Entity

var slot := InventorySlot.new()

@onready var _heat_provider: HeatProvider = $HeatProvider
@onready var _fire: AnimatedSprite2D = $FireAnimation

var _current_slot_value := 0


func _ready():
	Events.system_tick.connect(_on_system_tick)


func _on_material_enter_area_body_entered(body: Node2D):
	if not body.is_in_group("ore"):
		return

	var entity := body as GroundEntity
	if not entity:
		return

	entity.queue_free()
	slot.stack += 1


func _on_system_tick(_delta):
	if not slot.empty() and _current_slot_value <= 0:
		slot.stack -= 1
		_current_slot_value = slot.data.value

	if _current_slot_value >= 0:
		_current_slot_value -= self.data.amount
		_heat_provider.amount = self.data.value

	if _heat_provider.amount > 0:
		_fire.show()
		SoundManager.play("smelter_active")
	else:
		_fire.hide()
