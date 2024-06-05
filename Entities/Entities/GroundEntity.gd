class_name GroundEntity
extends Entity

@export var is_draggable := false
@export var is_collectable := false
@export var is_destructable := false

var velocity := Vector2.ZERO
var friction := 0.95


func add_force(force: Vector2) -> void:
	velocity += force


func _physics_process(delta):
	velocity -= (velocity) * friction * delta

	if velocity.length() < friction:
		velocity = Vector2.ZERO

	if has_method("move_and_collide"):
		call("move_and_collide", velocity * delta)
	else:
		position += velocity * delta
