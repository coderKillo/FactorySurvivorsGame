extends Entity

@export var speed = 15

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	Events.system_tick.connect(_on_system_tick)


func _on_system_tick(_delta):
	_sync_animation()


func _sync_animation():
	var time_sek = Time.get_ticks_msec() / 1000.0
	var frame_duration = 0.2
	var total_duration = 15 * frame_duration
	var time_in_animation = fmod(time_sek, total_duration)

	_animation.play("active")
	_animation.set_frame_and_progress(
		int(time_in_animation / frame_duration), fmod(time_in_animation, frame_duration)
	)


func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		var character := body as CharacterBody2D
		character.velocity += _get_velocity()

	if body.is_in_group("ore"):
		var ore := body as Ore
		ore.velocity += _get_velocity()


func _on_body_exited(body: Node2D):
	if body is CharacterBody2D:
		var character := body as CharacterBody2D
		character.velocity -= _get_velocity()

	if body.is_in_group("ore"):
		var ore := body as Ore
		ore.velocity -= _get_velocity()


func _get_velocity() -> Vector2:
	return Vector2.RIGHT.rotated(global_rotation) * speed
