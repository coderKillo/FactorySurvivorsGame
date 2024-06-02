extends Node2D

var damage = 20
var delay = 3  # in sec

@onready var _hit_area: Area2D = $Area2D
@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	_charge()


func _physics_process(_delta):
	_explode()


func _charge() -> void:
	set_physics_process(false)

	_animation.play("charge")

	await _animation.animation_finished

	set_physics_process(true)


func _explode() -> void:
	set_physics_process(false)

	_damage()

	Events.camera_shake.emit(8.0)
	SoundManager.play("explosive")

	_animation.play("explode")

	await _animation.animation_finished

	queue_free()


func _damage() -> void:
	for body in _hit_area.get_overlapping_bodies():
		var destruction := body.get_node_or_null("DestructionComponent") as DestructionComponent
		if destruction != null:
			destruction.destruct(damage)

	for area in _hit_area.get_overlapping_areas():
		var hurt_box = area as HurtBoxComponent
		if hurt_box != null:
			hurt_box.take_damage(damage, global_position)
