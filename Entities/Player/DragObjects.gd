class_name DragObjects
extends Area2D

signal charge_time_updated(time: float)

@export var max_distance = 9
@export var max_charge_time := 1.0
@export var max_charge_push := 200

var is_charging := false
var is_graped := false

var _charge_time := 0.0:
	set(value):
		_charge_time = value
		charge_time_updated.emit(_charge_time)


func grab():
	is_graped = true


func charge():
	is_charging = true


func release():
	is_charging = false

	_push_bodies_in_mouse_direction()

	is_graped = false


func bodies_grabed() -> int:
	return len(get_bodies())


func _draw():
	for body in get_bodies():
		draw_line(position, to_local(body.global_position), Color.BLACK, 1.0)


func _process(delta):
	if is_charging:
		_charge_time += delta
	else:
		_charge_time = 0.0


func _physics_process(_delta):
	for body in get_bodies():
		var distance = body.global_position.distance_to(global_position)
		var direction = body.global_position.direction_to(global_position)
		var entity := body as GroundEntity
		var player_velocity = owner.velocity
		var player_direction = player_velocity.normalized()
		var player_speed = player_velocity.length()

		if not entity.is_draggable:
			continue

		if distance < max_distance:
			continue

		entity.velocity = (player_direction + direction).normalized() * player_speed

	queue_redraw()


func get_bodies() -> Array:
	var bodies := []
	if not is_graped:
		return bodies

	for body in get_overlapping_bodies():
		bodies.append(body)
		if len(bodies) >= UpgradeData.player_data.max_bodies:
			break

	return bodies


func _push_bodies_in_mouse_direction() -> void:
	for body in get_bodies():
		var entity := body as GroundEntity
		var direction = body.global_position.direction_to(get_global_mouse_position())
		var charge_factor = min(_charge_time, max_charge_time) / max_charge_time

		if not entity.is_draggable:
			continue

		entity.add_force(max_charge_push * direction * charge_factor)
