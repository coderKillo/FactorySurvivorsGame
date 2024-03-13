extends Entity

@onready var _power: PowerOnDemand = $PowerReceiver
@onready var _worker: WorkComponent = $WorkComponent
@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D


func _process(_delta):
	_worker.pickup_time = self.data.speed * 1.0
	_worker.process_time = self.data.speed * 2.0

	if _power.efficency >= 1.0:
		_animation.play()
		_worker.start()
	else:
		_animation.stop()
		_worker.stop()


func _physics_process(_delta):
	_power.set_active(_worker.has_available_work())
