extends Entity

@export var damage = 50
@export var rate = 2

@onready var _animation: AnimationPlayer = $AnimationPlayer
@onready var _area: Area2D = $Area2D
@onready var _timer: Timer = $Timer
@onready var _power_receiver: PowerReceiver = $PowerReceiver

var _is_ready = true


func _ready():
	_timer.timeout.connect(_on_timer_timeout)
	_power_receiver.received_power.connect(_on_power_received)
	_power_receiver.power_required = 0


func _physics_process(_delta):
	if not _is_ready:
		return

	_power_receiver.power_required = 4 if _area.has_overlapping_bodies() else 0


func _on_timer_timeout():
	_is_ready = true


func _on_power_received(amount, _delta):
	if (amount <= 0) or (amount < _power_receiver.power_required) or (not _is_ready):
		return

	_power_receiver.power_required = 0

	_timer.start(rate)
	_is_ready = false

	_animation.play("active")


func _do_damage():
	for body in _area.get_overlapping_bodies():
		var health = body.get_node_or_null("Health") as Health
		if health != null:
			health.damage(damage)
