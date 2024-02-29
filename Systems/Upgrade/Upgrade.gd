class_name Upgrade
extends Resource

@export var title: String
@export var type: String
@export var object: String
@export var unique := false

@export_multiline var description: String

@export var requirements: Dictionary


func upgrade_name() -> String:
	return resource_path.substr(resource_path.rfind("/") + 1)
