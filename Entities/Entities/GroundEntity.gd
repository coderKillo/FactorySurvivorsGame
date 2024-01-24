class_name GroundEntity
extends Entity

@export var entity_name: String = ""
@export var is_draggable := false
@export var is_collectable := false


func get_entity_name() -> String:
	return entity_name
