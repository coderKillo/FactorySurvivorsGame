extends Entity

@export var speed = 15

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _power: PowerReceiver = $PowerReceiver
@onready var _collision: CollisionShape2D = $CollisionShape2D

var _active = false


func _ready():
	_power.received_power.connect(_on_received_power)
	_collision.disabled = true


func _on_received_power(amount, _delta):
	var active = amount >= _power.power_required

	if active != _active:
		_active = active
		_set_animation()
		_collision.disabled = not _active


func _set_animation():
	if _active:
		_start_sync_animation()
	else:
		_animation.pause()


func _start_sync_animation():
	var time_sek = Time.get_ticks_msec() / 1000.0
	var frame_duration = 0.2
	var total_duration = 15 * frame_duration
	var time_in_animation = fmod(time_sek, total_duration)

	_animation.play("active")
	_animation.set_frame_and_progress(
		int(time_in_animation / frame_duration), fmod(time_in_animation, frame_duration)
	)


func _on_body_entered(body: Node2D):
	if not _active:
		return

	if body is CharacterBody2D:
		var character := body as CharacterBody2D
		character.velocity += _get_velocity()

	if body.is_in_group("ore"):
		var ore := body as Ore
		ore.velocity += _get_velocity()


func _on_body_exited(body: Node2D):
	if not _active:
		return

	if body is CharacterBody2D:
		var character := body as CharacterBody2D
		character.velocity -= _get_velocity()

	if body.is_in_group("ore"):
		var ore := body as Ore
		ore.velocity -= _get_velocity()


func _get_velocity() -> Vector2:
	return Vector2.RIGHT.rotated(global_rotation) * speed
