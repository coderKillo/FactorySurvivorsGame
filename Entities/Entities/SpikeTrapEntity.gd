extends Entity

@export var damage = 50
@export var rate = 2

@onready var _animation: AnimationPlayer = $AnimationPlayer
@onready var _area: Area2D = $Area2D
@onready var _power: PowerOnDemand = $PowerReceiver


func _physics_process(_delta):
	_power.set_active(_area.as_overlapping_bodies())


func _process(_delta):
	if _power.efficency >= 1.0:
		_animation.play("active")


func _do_damage():
	for area in _area.get_overlapping_areas():
		var hurt_box = area as HurtBoxComponent
		if hurt_box != null:
			hurt_box.take_damage(damage)
