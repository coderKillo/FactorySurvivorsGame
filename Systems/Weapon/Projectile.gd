class_name Projectile
extends Area2D

@export var speed = 750
@export var damage = 10
@export var cost = 10

@onready var _sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _animation: AnimationPlayer = $AnimationPlayer


func _ready():
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	_sprite_animation.play("default")


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_body_entered(_body: PhysicsBody2D):
	_destroy_projectile()


func _on_area_entered(area: Area2D):
	var hurt_box = area as HurtBoxComponent
	if hurt_box != null:
		hurt_box.take_damage(damage)

	_destroy_projectile()


func _destroy_projectile():
	_animation.play("Hit")
