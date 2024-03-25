extends Entity

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _power_source: PowerSource = $PowerSource
@onready var _heat_receiver: HeatReceiver = $HeatReceiver
@onready var _molt_bucket: Bucket = $MoltBucket


func _ready():
	_heat_receiver.matieral_provided.connect(_on_heat_provided)
	_animation.play("idle")
	Events.system_tick.connect(_on_system_tick)


func _on_heat_provided(amount):
	_molt_bucket.put(amount)


func _on_system_tick(_delta):
	_heat_receiver.required_heat = self.data.amount
	_power_source.power_amount = self.data.value

	var amount = _molt_bucket.take(_heat_receiver.required_heat)

	_power_source.efficency = amount / float(_heat_receiver.required_heat)

	if _power_source.efficency > 0.0:
		_animation.play("active")
		SoundManager.play("powerplant_active")
	if _power_source.efficency == 0.0:
		_animation.play("idle")
