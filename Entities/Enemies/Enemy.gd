class_name Enemy
extends CharacterBody2D

@export var damage = 10
@export var speed = 20
@export var attack_range = 8
@export var target: Node2D = null

enum States { IDLE, MOVE, ATTACK }

var _current_state: States = States.IDLE
var _last_direction := Vector2.ZERO

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _health: Health = $Health


func _ready():
	_health.death.connect(_on_death)


func _process(_delta):
	if target == null:
		_current_state = States.IDLE
	elif position.distance_to(target.position) < attack_range:
		_current_state = States.ATTACK
	else:
		_current_state = States.MOVE

	_set_animation()


func _physics_process(_delta):
	var direction = Vector2.ZERO

	if _current_state == States.MOVE:
		direction = position.direction_to(target.position)

	# only add direction change to velocity
	var direction_diff = direction - _last_direction
	velocity += direction_diff * speed
	_last_direction = direction

	move_and_slide()


func _set_animation() -> void:
	if _current_state == States.IDLE:
		_animation.play("idle")

	elif _current_state == States.MOVE:
		_animation.play("walk")
		_face_target()

	elif _current_state == States.ATTACK:
		_animation.play("attack")
		_face_target()


func _face_target():
	var direction = position.direction_to(target.position)

	if direction.x > 0:
		_animation.flip_h = false
	elif direction.x < 0:
		_animation.flip_h = true


func _on_death():
	Events.enemy_died.emit(self)

	queue_free()
