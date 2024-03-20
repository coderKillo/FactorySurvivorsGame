extends Entity

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _area: Area2D = $Area2D
@onready var _collision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var _marker: Marker2D = $Marker2D

var _bodies: Array[PhysicsBody2D] = []


func _ready():
	_area.body_entered.connect(_on_body_entered)
	_area.body_exited.connect(_on_body_exited)

	_start_sync_animation()


func _physics_process(delta):
	for body in _bodies:
		if _collision.shape.get_rect().has_point(body.global_position - global_position):
			var motion = (
				body.global_position.move_toward(_marker.global_position, self.data.speed * delta)
				- body.global_position
			)
			body.move_and_collide(motion)


func _on_body_exited(body):
	_bodies.erase(body)


func _on_body_entered(body):
	_bodies.append(body)


func _start_sync_animation():
	var time_sek = Time.get_ticks_msec() / 1000.0
	var frame_duration = 0.2
	var total_duration = 15 * frame_duration
	var time_in_animation = fmod(time_sek, total_duration)

	_animation.play("active")
	_animation.set_frame_and_progress(
		int(time_in_animation / frame_duration), fmod(time_in_animation, frame_duration)
	)
