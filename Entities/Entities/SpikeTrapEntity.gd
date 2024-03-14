extends Entity

@onready var _animation: AnimationPlayer = $AnimationPlayer
@onready var _area: Area2D = $Area2D
@onready var _power: PowerOnDemand = $PowerReceiver


func _physics_process(_delta):
	_power.set_active(_area.has_overlapping_bodies())


func _process(_delta):
	if _power.efficency >= 1.0:
		_animation.play("active")


func _do_damage():
	SoundManager.play("trap_active")
	for area in _area.get_overlapping_areas():
		var hurt_box = area as HurtBoxComponent
		if hurt_box != null:
			hurt_box.take_damage(self.data.damage)

			if hurt_box.owner.has_node_and_resource(":speed"):
				_apply_slow(hurt_box.owner)


func _apply_slow(body: Node) -> void:
	body.speed -= self.data.amount
	body.speed = max(0, body.speed)
