extends Node2D


func _ready():
	Events.ground_entity_spawn.connect(_on_ground_entity_spawn)


func _on_ground_entity_spawn(entity_name: String, pos: Vector2) -> void:
	var entity: Entity = Library.entites[entity_name].instantiate()
	entity.global_position = pos

	add_child(entity)
