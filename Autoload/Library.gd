extends Node

const BASE_PATH := "res://Entities"
const BLUEPRINT := "Blueprint.tscn"
const ENTITY := "Entity.tscn"

var blueprints = {}
var entites = {}


func _ready():
	_find_entities_in(BASE_PATH)


func get_entity_name(node: Node) -> String:
	if not node:
		return ""

	var filename = node.scene_file_path.substr(node.scene_file_path.rfind("/") + 1)
	filename = filename.replace(BLUEPRINT, "")
	filename = filename.replace(ENTITY, "")

	return filename


func _find_entities_in(path: String) -> void:
	var dir = DirAccess.open(path)
	if not dir:
		print("Error occured when try to access: ", path)
		return

	dir.list_dir_begin()

	var filename := dir.get_next()
	var dirname := dir.get_current_dir()
	while filename != "":
		if dir.current_is_dir():
			_find_entities_in(dirname + "/" + filename)
		else:
			if filename.ends_with(BLUEPRINT):
				var entity_name = filename.replace(BLUEPRINT, "")
				blueprints[entity_name] = load(dirname + "/" + filename)
			elif filename.ends_with(ENTITY):
				var entity_name = filename.replace(ENTITY, "")
				entites[entity_name] = load(dirname + "/" + filename)

		filename = dir.get_next()