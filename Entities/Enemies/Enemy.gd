class_name Enemy
extends CharacterBody2D

@export var speed = 20
@export var attack_range = 8
@export var destruction_count = 4
@export var target: Node2D = null

var color := ""

enum States { IDLE, MOVE, ATTACK, DEATH }

var _current_state: States = States.IDLE

@onready var model: ModelComponent = $ModelComponent
@onready var health: Health = $Health
@onready var weapon: EnemyWeapon = $Weapon

@onready var _hurt_box: HurtBoxComponent = $HurtBoxComponent


func _ready():
	health.death.connect(_on_death)
	_hurt_box.hit.connect(_on_hit)
	_hurt_box.push_back.connect(_on_hit_push_back)


func _process(_delta):
	if _current_state == States.DEATH:
		pass
	elif target == null:
		_current_state = States.IDLE
	elif _target_in_range():
		_current_state = States.ATTACK
	else:
		_current_state = States.MOVE

	_handle_states()


func _physics_process(_delta):
	if _current_state == States.DEATH:
		return

	var direction = Vector2.ZERO

	if _current_state == States.MOVE:
		direction = position.direction_to(target.position)

	velocity = lerp(velocity, direction * speed, 0.5)

	move_and_slide()


func _handle_states() -> void:
	if _current_state == States.IDLE:
		pass

	elif _current_state == States.MOVE:
		_face_target()

		model.play(EnemySpriteFrames.WALK)

	elif _current_state == States.ATTACK:
		_face_target()

		set_process(false)

		model.play(EnemySpriteFrames.ATTACK)
		await model.frame_changed
		await model.frame_changed

		weapon.fire()

		await model.animation_looped

		set_process(true)

	elif _current_state == States.DEATH:
		set_process(false)

		model.play(EnemySpriteFrames.DEATH)
		await model.animation_finished

		Events.enemy_died.emit(self)
		queue_free()


func _face_target():
	var direction = position.direction_to(target.position)

	weapon.look_at(target.global_position + Vector2(0, -3))

	if direction.x > 0:
		model.flip_h = false
		weapon.scale.x = -1
	elif direction.x < 0:
		model.flip_h = true
		weapon.scale.x = 1
		weapon.rotation_degrees += 180


func _target_in_range() -> bool:
	return target != null and global_position.distance_to(target.global_position) < attack_range


func _on_death():
	_current_state = States.DEATH


func _on_hit(_damage: int) -> void:
	model.hit(0.2)


func _on_hit_push_back(direction: Vector2) -> void:
	velocity = direction * 100
