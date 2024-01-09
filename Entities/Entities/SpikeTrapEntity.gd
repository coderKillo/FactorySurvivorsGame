extends Entity

@export var damage = 50
@export var rate = 2

@onready var _animation: AnimationPlayer = $AnimationPlayer
@onready var _area: Area2D = $Area2D
@onready var _power: PowerOnDemand = $PowerReceiver


func _physics_process(_delta):
	_power.set_active(_area.has_overlapping_bodies())


func _process(_delta):
	if _power.efficency >= 1.0:
		_animation.play("active")


func _do_damage():
	for body in _area.get_overlapping_bodies():
		var health = body.get_node_or_null("Health") as Health
		if health != null:
			health.damage(damage)
