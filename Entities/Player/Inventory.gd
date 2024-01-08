class_name Inventory
extends Node2D

signal inventory_changed(content)

var _content = {}


func add(item: String, amount: int):
	if not _content.has(item):
		_content[item] = 0

	_content[item] += amount
	inventory_changed.emit(_content)


func remove(item: String, amount: int):
	if not _content.has(item):
		return

	_content[item] -= amount
	_content[item] = max(0, _content[item])
	inventory_changed.emit(_content)
