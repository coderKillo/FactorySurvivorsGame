class_name Entity
extends Node2D

# object type that is allowed to destuct this object
@export var destruction_filter: String

# number of entities to create when destructing this object
@export var pickup_count: int = 1


func _setup(_blueprint):
	pass
