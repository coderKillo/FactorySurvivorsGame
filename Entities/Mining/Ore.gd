class_name Ore
extends RigidBody2D

var velocity := Vector2.ZERO

var _damp = 0.02


func _integrate_forces(state):
	if velocity != Vector2.ZERO:
		state.linear_velocity = velocity
		state.angular_velocity = 0
	else:
		state.linear_velocity = lerp(state.linear_velocity, Vector2.ZERO, _damp)
		state.angular_velocity = lerp(state.angular_velocity, 0.0, _damp)
