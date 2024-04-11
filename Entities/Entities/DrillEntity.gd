class_name DrillEntity
extends Entity

const ANIMATION_TIME = 4.0
const DESTRICTION_TIME = 12.0 / 19.0  # destction happen on 12th frame

@onready var _area: Area2D = $Area2D
@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D

var _components: Array[DestructionComponent]
var _worker := 0


func _ready():
	set_process(false)
	_set_animation_speed()

	# wait till physics is ready
	var timer = get_tree().create_timer(0.5)
	await timer.timeout

	_get_destriction_components()
	set_process(true)


func _process(_delta):
	if _worker <= 0:
		_destroy()


func _get_destriction_components() -> void:
	for body in _area.get_overlapping_bodies():
		var destruction := body.get_node_or_null("DestructionComponent") as DestructionComponent
		if destruction != null:
			_components.append(destruction)

		if len(_components) >= (self.data.amount * self.data.value):
			break

	_start_destruction()


func _set_animation_speed() -> void:
	_animation.speed_scale = self.data.speed


func _start_destruction() -> void:
	_destruct(_animation)

	# parallel worker
	for _i in self.data.value - 1:
		var animation = _animation.duplicate()
		add_child(animation)
		_destruct(animation)


func _destruct(animation: AnimatedSprite2D) -> void:
	_worker += 1

	while not _components.is_empty():
		var destruction_component = _components.pop_front()
		while destruction_component != null and not destruction_component.empty():
			animation.global_position = destruction_component.global_position
			animation.play("work")

			var destruction_time = DESTRICTION_TIME * ANIMATION_TIME / self.data.speed
			await get_tree().create_timer(destruction_time).timeout

			if destruction_component != null:
				destruction_component.destruct(self.data.damage)

			await animation.animation_finished

	animation.queue_free()

	_worker -= 1


func _destroy() -> void:
	queue_destruction = true
