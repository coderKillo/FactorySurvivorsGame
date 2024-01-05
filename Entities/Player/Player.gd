extends CharacterBody2D

@export var movement_speed = 300.0

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _weapon: Weapon = $Weapon


func _physics_process(_delta):
	var input_direction = (
		Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		. normalized()
	)

	set_animation(input_direction)

	velocity = input_direction * movement_speed

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
