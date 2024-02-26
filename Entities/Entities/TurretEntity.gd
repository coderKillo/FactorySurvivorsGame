class_name TurretEntity
extends Entity

@export var ProjectileScene = preload("res://Systems/Weapon/ProjectileBig.tscn")

@onready var _area: Area2D = $Area2D
@onready var _power: PowerOnDemand = $PowerReceiver
@onready var _shoot_position: Marker2D = $Marker2D
@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _projectiles: Node2D = $Projectiles

var _is_attacking = false
var _target: Node2D


func _ready():
	_animation.play("idle")
	_animation.speed_scale = speed


func _physics_process(_delta):
	_power.set_active(_area.has_overlapping_areas())

	if not _area.has_overlapping_areas():
		return

	if _target == null:
		_target = _area.get_overlapping_areas().pick_random()

	_face_target()
	_aim_projectiles_at_target()


func _aim_projectiles_at_target():
	for projectile in _projectiles.get_children():
		projectile.look_at(_target.global_position)


func _face_target():
	var direction = global_position.direction_to(_target.global_position)
	var x = _shoot_position.position.x

	if direction.x > 0:
		_animation.flip_h = false
		_shoot_position.position.x = -x if x < 0 else x
	elif direction.x < 0:
		_animation.flip_h = true
		_shoot_position.position.x = -x if x > 0 else x

	if direction.x * _shoot_position.position.x < 0:
		_shoot_position.position.x *= -1


func _process(_delta):
	if _power.efficency >= 1.0:
		_attack()


func _attack():
	if _is_attacking:
		return

	_is_attacking = true
	_animation.play("anticipation")
	await _animation.animation_finished

	if _target != null:
		_fire()

	_animation.play("recovery")
	await _animation.animation_finished

	_is_attacking = false
	_animation.play("idle")


func _fire():
	var projectile: Projectile = ProjectileScene.instantiate()
	projectile.transform = _shoot_position.transform
	projectile.damage = damage

	_projectiles.add_child(projectile)
