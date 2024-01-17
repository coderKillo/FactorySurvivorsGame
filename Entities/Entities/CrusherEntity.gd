extends Entity

@onready var _power: PowerOnDemand = $PowerReceiver
@onready var _input: Area2D = $InputArea
@onready var _ouput: Area2D = $OuputArea
@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _timer: Timer = $Timer

var Ore = preload("res://Entities/Mining/Ore.tscn")


func _ready():
	_timer.timeout.connect(_on_timer_timeout)


func _process(_delta):
	if _power.efficency >= 1.0:
		_animation.play()
		if _timer.is_stopped():
			_timer.start(0.5)
	else:
		_animation.stop()
		_timer.stop()


func _physics_process(_delta):
	_power.set_active(_input.has_overlapping_bodies())


func _on_timer_timeout():
	var ore = Ore.instantiate()
	ore.position = _ouput.position

	call_deferred("add_child", ore)
