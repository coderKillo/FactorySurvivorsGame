extends Entity

@onready var _power: PowerReceiver = $PowerReceiver
@onready var _worker: WorkComponent = $WorkComponent
@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	_power.received_power.connect(_on_received_power)


func _process(_delta):
	_worker.pickup_time = self.data.speed * 1.0
	_worker.process_time = self.data.speed * 2.0
	_power.power_required = self.data.energy_cost


func _on_received_power(amount, _delta):
	if amount >= _power.power_required:
		_animation.play()
		_worker.start()
	else:
		_animation.stop()
		_worker.stop()
