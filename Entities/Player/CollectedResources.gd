class_name CollectedResources
extends Resource

signal collection_changed(collection)

var collection: Dictionary = {}


func add_item(name: String) -> void:
	if name not in collection:
		collection[name] = Library.blueprints[name].instantiate()
		collection[name].stack_count = 0
	collection[name].stack_count += 1
	collection_changed.emit(collection)


func remove_item(name: String) -> bool:
	if name not in collection:
		return false
	collection[name].stack_count -= 1
	collection_changed.emit(collection)
	return true
