class_name Projectile
extends Area2D

@export var speed = 750
@export var damage = 10
@export var cost = 10

@onready var _sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var _animation: AnimationPlayer = $AnimationPlayer


func _ready():
	_sprite_animation.play("default")


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_body_entered(body: Node2D):
	if body.is_in_group(Types.ENEMY):
		var health = body.get_node_or_null("Health") as Health
		if health != null:
			health.damage(damage)

	_animation.play("Hit")
