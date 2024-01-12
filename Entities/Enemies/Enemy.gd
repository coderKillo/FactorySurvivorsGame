class_name Enemy
extends CharacterBody2D

@export var damage = 2
@export var speed = 20
@export var attack_range = 8
@export var target: Node2D = null

enum States { IDLE, MOVE, ATTACK, DEATH }

var _current_state: States = States.IDLE

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _health: Health = $Health


func _ready():
	_health.death.connect(_on_death)
	_animation.animation_looped.connect(_on_animation_looped)


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
		_animation.play("idle")

	elif _current_state == States.MOVE:
		_animation.play("walk")
		_face_target()

	elif _current_state == States.ATTACK:
		_animation.play("attack")
		_face_target()

	elif _current_state == States.DEATH:
		if _animation.animation != "death":
			_animation.play("death")


func _face_target():
	var direction = position.direction_to(target.position)

	if direction.x > 0:
		_animation.flip_h = false
	elif direction.x < 0:
		_animation.flip_h = true


func _on_animation_looped():
	if _animation.animation == "attack":
		_attack()


func _attack():
	if not _target_in_range():
		return

	var health = target.get_node_or_null("Health") as Health
	if health != null:
		health.damage(damage)


func _target_in_range() -> bool:
	return target != null and global_position.distance_to(target.global_position) < attack_range


func _on_death():
	Events.enemy_died.emit(self)

	_current_state = States.DEATH

	# remove from enemy layer
	set_collision_layer_value(2, false)
	set_collision_mask_value(2, false)
	# add to draggable object
	set_collision_layer_value(3, true)
	set_collision_mask_value(3, false)

	$CollisionShapeAlive.set_deferred("disabled", true)
	$CollisionShapeCorpse.set_deferred("disabled", false)
