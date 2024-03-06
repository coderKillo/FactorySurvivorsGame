class_name Projectile
extends Area2D

@export var speed = 750
@export var damage = 10
@export var cost = 10
@export var range = 500
@export var impact_sound := "projectile_hit"

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	_animation.play("default")


func _physics_process(delta):
	var distance = transform.x * speed * delta
	position += distance
	range -= distance.length()

	if range <= 0:
		queue_free()


func _on_body_entered(_body: PhysicsBody2D):
	_destroy_projectile()


func _on_area_entered(area: Area2D):
	var hurt_box = area as HurtBoxComponent
	if hurt_box != null:
		hurt_box.take_damage(damage)

	_destroy_projectile()


func _destroy_projectile():
	call_deferred("set_physics_process", false)
	$CollisionShape2D.set_deferred("disabled", true)

	_animation.play("impact")
	SoundManager.play(impact_sound)

	global_rotation_degrees = 0
	await _animation.animation_finished

	queue_free()
