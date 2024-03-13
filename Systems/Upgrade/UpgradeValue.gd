@tool
class_name UpgradeValue
extends Resource

enum Operation {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
	ASSIGN,
}

@export var path := ""
@export var operation := Operation.ADD
@export var type := TYPE_INT:
	set(value):
		type = value
		property_list_changed.emit()

var upgrade_value: Variant


func _get_property_list():
	return [{name = "upgrade_value", type = type}]


func apply(source: Node) -> void:
	var r = source.get_node_and_resource(path)

	var node := r[0] as Node
	var resource := r[1] as Resource
	var property_path := r[2] as NodePath
	var object: Object

	if property_path.is_empty() and resource:
		var subnames = NodePath(path).get_concatenated_subnames()
		property_path = NodePath(subnames).get_as_property_path()

	if resource:
		object = resource
	else:
		object = node

	match operation:
		Operation.ADD:
			object.set_indexed(property_path, object.get_indexed(property_path) + upgrade_value)

		Operation.SUBTRACT:
			object.set_indexed(property_path, object.get_indexed(property_path) - upgrade_value)

		Operation.MULTIPLY:
			object.set_indexed(property_path, object.get_indexed(property_path) * upgrade_value)

		Operation.DIVIDE:
			object.set_indexed(property_path, object.get_indexed(property_path) * upgrade_value)

		Operation.ASSIGN:
			object.set_indexed(property_path, upgrade_value)
