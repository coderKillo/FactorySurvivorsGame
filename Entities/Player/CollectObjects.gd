class_name CollectObjects
extends Area2D

signal entity_collected(ground: GroundEntity)

@export var collect_distance = 1
@export var collect_gravity = 100


func _physics_process(delta):
	for body in get_overlapping_bodies():
		var distance = global_position.distance_to(body.global_position)
		var entity := body as GroundEntity

		if entity == null or not entity.is_collectable:
			continue

		if distance < collect_distance:
			entity_collected.emit(entity)
			entity.queue_free()
			continue

		body.global_position = body.global_position.move_toward(
			global_position, delta * collect_gravity
		)
