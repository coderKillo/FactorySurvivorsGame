class_name OreCollector
extends Area2D

signal ore_collected(value)

@export var collect_distance = 1
@export var collect_gravity = 100


func _physics_process(delta):
	for body in get_overlapping_bodies():
		var distance = global_position.distance_to(body.global_position)
		var ore := body as Ore

		if ore != null and distance < collect_distance:
			body.queue_free()
			ore_collected.emit(ore.value)
			continue

		body.global_position = body.global_position.move_toward(
			global_position, delta * collect_gravity
		)
