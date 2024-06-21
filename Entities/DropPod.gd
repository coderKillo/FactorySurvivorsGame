class_name DropPod
extends Node2D

signal opened

@onready var _left_shell: RigidBody2D = $LeftShell
@onready var _right_shell: RigidBody2D = $RightShell


func _ready():
	pass


func land():
	Events.spawn_effect.emit("shatter", global_position + Vector2(0, 8))
	Events.camera_shake.emit(4.0)


func open():
	var y_velocity = randf_range(10, 20)
	var x_velocity = randf_range(100, 150)
	var angular_veclocity = randf_range(3, 10)

	_left_shell.linear_velocity = Vector2(-x_velocity, -y_velocity)
	_left_shell.angular_velocity = -angular_veclocity
	_left_shell.constant_force = Vector2(-x_velocity / 10, -y_velocity)
	_right_shell.linear_velocity = Vector2(x_velocity, -y_velocity)
	_right_shell.angular_velocity = -angular_veclocity
	_right_shell.constant_force = Vector2(x_velocity / 10, -y_velocity)

	Events.spawn_effect.emit("smoke_explosive", global_position)
	Events.camera_shake.emit(2.0)

	opened.emit()
