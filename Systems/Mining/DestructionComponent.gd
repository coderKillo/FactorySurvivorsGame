class_name DestructionComponent
extends Node2D

# object type that is allowed to destuct this object
@export var destruction_filter: String
# entity type that is spawned on destruction
@export var destruction_entity: String
# number of entities to create when destructing this object
@export var pickup_count: int = 4


func destruct() -> void:
	var random_offset = Vector2(randi_range(-10, 10), randi_range(-10, 10))
	Events.ground_entity_spawn.emit(destruction_entity, global_position + random_offset)

	pickup_count -= 1
	if pickup_count <= 0:
		owner.queue_free()
