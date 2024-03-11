class_name Enemy
extends CharacterBody2D

@export var damage = 2
@export var speed = 20
@export var attack_range = 8
@export var destruction_count = 4
@export var target: Node2D = null

var color := ""

enum States { IDLE, MOVE, ATTACK, DEATH }

var _current_state: States = States.IDLE

@onready var model: ModelComponent = $ModelComponent
@onready var health: Health = $Health


func _ready():
	health.death.connect(_on_death)
	model.animation_looped.connect(_on_animation_looped)
	model.animation_finished.connect(_on_animation_finished)


func _process(_delta):
	if _current_state == States.DEATH:
		pass
	elif target == null:
		_current_state = States.IDLE
	elif _target_in_range():
		_current_state = States.ATTACK
	else:
		_current_state = States.MOVE

	_set_animation()


func _physics_process(_delta):
	if _current_state == States.DEATH:
		return

	var direction = Vector2.ZERO

	if _current_state == States.MOVE:
		direction = position.direction_to(target.position)

	velocity = direction * speed

	move_and_slide()


func _set_animation() -> void:
	if _current_state == States.IDLE:
		pass

	elif _current_state == States.MOVE:
		model.play(EnemySpriteFrames.WALK)
		_face_target()

	elif _current_state == States.ATTACK:
		model.play(EnemySpriteFrames.ATTACK)
		_face_target()

	elif _current_state == States.DEATH:
		model.play(EnemySpriteFrames.DEATH)


func _face_target():
	var direction = position.direction_to(target.position)

	if direction.x > 0:
		model.flip_h = false
	elif direction.x < 0:
		model.flip_h = true


func _on_animation_looped():
	if model.animation == EnemySpriteFrames.ATTACK:
		_attack()


func _on_animation_finished():
	if model.animation == EnemySpriteFrames.DEATH:
		Events.enemy_died.emit(self)
		queue_free()


func _attack():
	if not _target_in_range():
		return

	SoundManager.play("enemy_attack")

	var hurt_box = target.get_node_or_null("HurtBoxComponent") as HurtBoxComponent
	if hurt_box != null:
		hurt_box.take_damage(damage)


func _target_in_range() -> bool:
	return target != null and global_position.distance_to(target.global_position) < attack_range


func _on_death():
	_current_state = States.DEATH
