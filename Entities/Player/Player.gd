extends CharacterBody2D

@export var movement_speed = 300.0

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _weapon: Weapon = $Weapon
@onready var _drag_objects: DragObjects = $DragObjects


func _physics_process(_delta):
	var input_direction = (
		Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		. normalized()
	)

	set_animation(input_direction)

	var speed = movement_speed
	# reduce speed the more bodies are grabed with a maximum of 10
	speed /= min(10, _drag_objects.bodies_grabed() + 1)

	velocity = input_direction * speed

	move_and_slide()


func _unhandled_input(event):
	if event.is_action("left_click"):
		_weapon.fire(event.is_pressed())

	if event.is_action_pressed("grab"):
		_drag_objects.grab()
	if event.is_action_released("grab"):
		_drag_objects.release()


func set_animation(direction: Vector2):
	if direction:
		_animation.play("walk")
	else:
		_animation.play("idle")

	_animation.flip_h = _weapon.is_right
