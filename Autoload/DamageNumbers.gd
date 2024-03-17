extends Node

@onready var DamageNumberScene: PackedScene = preload("res://GUI/DamageNumber.tscn")


func display(value: int, pos: Vector2) -> void:
	var number := DamageNumberScene.instantiate() as Node2D
	number.global_position = pos
	number.get_node("Label").text = str(value)

	call_deferred("add_child", number)

	var tween = get_tree().create_tween()

	tween.tween_property(number, "position:y", number.position.y - 5, 0.75).set_ease(Tween.EASE_OUT)
	tween.tween_property(number, "scale", Vector2.ZERO, 0.25).set_ease(Tween.EASE_OUT)

	await tween.finished

	number.queue_free()
