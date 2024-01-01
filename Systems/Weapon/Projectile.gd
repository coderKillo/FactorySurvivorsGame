extends Area2D

@export var speed = 750


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_body_entered(body: Node2D):
	if body.is_in_group(Types.ENEMY):
		# TODO: replace with damage
		body.queue_free()

	queue_free()
