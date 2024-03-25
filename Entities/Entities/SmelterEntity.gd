extends Entity

const OVERHEAT_TIME = 20  # sek
const HEAT_PER_SEK = 10

@onready var _heat_provider: HeatProvider = $HeatProvider
@onready var _fire: AnimatedSprite2D = $FireAnimation
@onready var _ore_bucket: Bucket = $OreBucket
@onready var _heat_bucket: Bucket = $HeatBucket
@onready var _molt_bucket: Bucket = $MoltBucket
@onready var _smoke: GPUParticles2D = $Smoke


func _ready():
	_heat_bucket._limit = OVERHEAT_TIME * HEAT_PER_SEK

	Events.system_tick.connect(_on_system_tick)


func _on_material_enter_area_body_entered(body: Node2D):
	if not body.is_in_group("ore"):
		return

	var entity := body as GroundEntity
	if not entity:
		return

	if _ore_bucket.full():
		return

	_ore_bucket.put(entity.data.value)
	entity.queue_free()


func _on_system_tick(delta):
	_smoke.emitting = false

	if _heat_bucket.full():
		_smoke.emitting = true
		_fire.hide()
		return

	if _ore_bucket.empty():
		_fire.hide()
		return

	if not _molt_bucket.full():
		_provide_molt()

	_update_heat(delta)

	_fire.show()
	SoundManager.play("smelter_active")


func _provide_molt() -> void:
	_ore_bucket.take(self.data.value)
	if self.data.upgrade_2:
		_heat_provider.amount += self.data.amount
	else:
		_molt_bucket.put(self.data.amount)


func _update_heat(delta) -> void:
	if self.data.upgrade_1:
		if _molt_bucket.full():
			_heat_bucket.put(HEAT_PER_SEK * delta)
	else:
		_heat_bucket.put(HEAT_PER_SEK * delta)
