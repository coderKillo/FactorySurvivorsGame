extends Entity

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _area: Area2D = $Area2D
@onready var _collision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var _marker: Marker2D = $Marker2D

var _bodies: Array[PhysicsBody2D] = []


func _ready():
	_area.body_entered.connect(_on_body_entered)
	_area.body_exited.connect(_on_body_exited)

	Events.system_tick.connect(_on_system_tick)


func _physics_process(delta):
	for body in _bodies:
		if not _collision.shape.get_rect().has_point(_collision.to_local(body.global_position)):
			continue

		var origin = body.global_position
		var destination = origin.move_toward(_marker.global_position, self.data.speed * delta)
		var motion = destination - origin

		body.move_and_collide(motion)


func _on_body_exited(body):
	_bodies.erase(body)


func _on_body_entered(body):
	_bodies.append(body)


func _sync_animation():
	var time_sek = Time.get_ticks_msec() / 1000.0
	var frame_duration = 0.1
	var total_duration = 16 * frame_duration
	var time_in_animation = fmod(time_sek, total_duration)

	_animation.stop()
	_animation.frame = floor(time_in_animation / frame_duration)


func _on_system_tick(_delta):
	_sync_animation()
