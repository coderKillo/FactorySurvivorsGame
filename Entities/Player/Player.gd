extends CharacterBody2D

@export var movement_speed = 300.0

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _weapon: Weapon = $Weapon

var _last_direction := Vector2.ZERO


func _physics_process(_delta):
	var input_direction = (
		Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		. normalized()
	)

	set_animation(input_direction)

	# only add direction change to velocity
	var direction_diff = input_direction - _last_direction
	velocity += direction_diff * movement_speed
	_last_direction = input_direction

	move_and_slide()


func _unhandled_input(event):
	if event.is_action("left_click"):
		_weapon.fire(event.is_pressed())


func set_animation(direction: Vector2):
	if direction:
		_animation.play("walk")
	else:
		_animation.play("idle")

	if direction.x > 0:
		_animation.flip_h = true
	elif direction.x < 0:
		_animation.flip_h = false
