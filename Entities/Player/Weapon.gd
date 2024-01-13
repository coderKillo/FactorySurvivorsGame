class_name Weapon
extends Node2D

@export var fire_rate = 0.3
@export var damage = 10

var is_right = false

var _firing = false
var _on_cooldown = false
var _cooldown_timer: Timer


func setup(timer: Timer):
	_cooldown_timer = timer
	_cooldown_timer.timeout.connect(_on_cooldown_timeout)


func _process(_delta):
	var mouse = get_global_mouse_position()
	look_at(mouse)

	_set_weapon_direction(mouse)

	if _firing and not _on_cooldown:
		show()

		_fire()

		_on_cooldown = true
		_cooldown_timer.start(fire_rate)

	elif not _firing and not _on_cooldown:
		hide()


func fire(pressed: bool):
	_firing = pressed


func _on_cooldown_timeout():
	_on_cooldown = false


func _set_weapon_direction(pos: Vector2):
	is_right = pos.x > global_position.x

	_update_weapon_direction()


func _update_weapon_direction():
	pass


func _fire():
	pass
