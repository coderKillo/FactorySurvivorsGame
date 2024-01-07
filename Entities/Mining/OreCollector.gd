class_name OreCollector
extends Area2D

@export var collect_distance = 1
@export var collect_gravity = 100

var amount = 0


func _physics_process(delta):
	for body in get_overlapping_bodies():
		var distance = global_position.distance_to(body.global_position)

		if distance < collect_distance:
			body.queue_free()
			amount += 1
			continue

		body.global_position = body.global_position.move_toward(
			global_position, delta * collect_gravity
		)
