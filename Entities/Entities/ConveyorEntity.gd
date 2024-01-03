extends Entity

@export var speed = 15

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	print(_get_velocity())
	_start()


func _start():
	_animation.play("active")


func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		var character := body as CharacterBody2D
		character.velocity += _get_velocity()

	if body.is_in_group("ore"):
		var ore := body as Ore
		ore.velocity += _get_velocity()


func _on_body_exited(body: Node2D):
	if body is CharacterBody2D:
		var character := body as CharacterBody2D
		character.velocity -= _get_velocity()

	if body.is_in_group("ore"):
		var ore := body as Ore
		ore.velocity -= _get_velocity()


func _get_velocity() -> Vector2:
	return Vector2.RIGHT.rotated(global_rotation) * speed
