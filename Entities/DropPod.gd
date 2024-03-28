class_name DropPod
extends Node2D

signal opened

@onready var _left_shell: RigidBody2D = $LeftShell
@onready var _right_shell: RigidBody2D = $RightShell


func _ready():
	pass


func open():
	_left_shell.linear_velocity = Vector2(randf_range(-250, -150), randf_range(-25, -10))
	_left_shell.angular_velocity = randf_range(-10, -3)
	_left_shell.constant_force = Vector2(0, randf_range(-20, -10))
	_right_shell.linear_velocity = Vector2(randf_range(150, 250), randf_range(-25, -10))
	_right_shell.angular_velocity = randf_range(3, 10)
	_right_shell.constant_force = Vector2(0, randf_range(-20, -10))
	opened.emit()
