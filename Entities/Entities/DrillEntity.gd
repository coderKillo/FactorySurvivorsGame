class_name DrillEntity
extends Entity

const ANIMATION_TIME = 4.0
const DESTRICTION_TIME = 12.0 / 19.0  # destction happen on 12th frame

@export var speed := 4
@export var max_bodies := 1

@onready var _area: Area2D = $Area2D
@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D

var _components: Array[DestructionComponent]


func _ready():
	_animation.animation_finished.connect(_on_animation_finished)
	_set_animation_speed()

	# wait till physics is ready
	var timer = get_tree().create_timer(0.5)
	await timer.timeout

	_get_destriction_components()


func _get_destriction_components() -> void:
	for body in _area.get_overlapping_bodies():
		var destruction := body.get_node_or_null("DestructionComponent") as DestructionComponent

		if destruction != null:
			_components.append(destruction)

		if len(_components) >= max_bodies:
			break

	_start_destruction()


func _set_animation_speed() -> void:
	_animation.speed_scale = ANIMATION_TIME / speed


func _on_animation_finished() -> void:
	_start_destruction()


func _start_destruction() -> void:
	if _components.is_empty():
		_destroy()
		return

	var destruction_component = _components.front()
	if destruction_component == null or destruction_component.pickup_count <= 0:
		_components.pop_front()
		_start_destruction()
		return

	_animation.global_position = destruction_component.global_position
	_animation.play("work")

	var timer = get_tree().create_timer(DESTRICTION_TIME * ANIMATION_TIME / speed)
	await timer.timeout

	if destruction_component != null:
		destruction_component.destruct()


func _destroy() -> void:
	queue_destruction = true
