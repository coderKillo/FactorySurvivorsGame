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


func apply(object: Object) -> void:
	var property_path := path as NodePath

	match operation:
		Operation.ADD:
			object.set_indexed(property_path, object.get_indexed(property_path) + upgrade_value)

		Operation.SUBTRACT:
			object.set_indexed(
				property_path, max(upgrade_value, object.get_indexed(property_path) - upgrade_value)
			)

		Operation.MULTIPLY:
			object.set_indexed(property_path, object.get_indexed(property_path) * upgrade_value)

		Operation.DIVIDE:
			object.set_indexed(property_path, object.get_indexed(property_path) * upgrade_value)

		Operation.ASSIGN:
			object.set_indexed(property_path, upgrade_value)
