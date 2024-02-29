extends Entity

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _power_source: PowerSource = $PowerSource
@onready var _heat_receiver: HeatReceiver = $HeatReceiver


func _ready():
	_heat_receiver.matieral_provided.connect(_on_heat_provided)
	_animation.play("idle")


func _process(_delta):
	_heat_receiver.required_heat = int(100 / float(value))


func _on_heat_provided(amount):
	_power_source.efficency = amount / _heat_receiver.required_heat

	if _power_source.efficency > 0.0:
		_animation.play("active")
	if _power_source.efficency == 0.0:
		_animation.play("idle")
