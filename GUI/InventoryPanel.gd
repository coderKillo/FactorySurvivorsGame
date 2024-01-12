class_name InventoryPanel
extends Panel

signal held_item_changed(panel, item)

var held_item: BlueprintEntity:
	set = _set_held_item

@onready var _lable: Label = $Label
@onready var _mask: Node2D = $Mask

var _gui: GUI


func setup(gui: GUI):
	_gui = gui


func _gui_input(event: InputEvent) -> void:
	var left_click := event.is_action_pressed("left_click")
	var right_click := event.is_action_pressed("right_click")

	if not (left_click or right_click):
		return

	var mouse_holds_item: bool = _gui.blueprint != null
	var inventory_holds_item: bool = held_item != null

	if mouse_holds_item and inventory_holds_item:
		if left_click:
			_swap_item()
	elif mouse_holds_item and not inventory_holds_item:
		if left_click:
			_release_item()
	elif not mouse_holds_item and inventory_holds_item:
		if left_click:
			_grep_item()


func _set_held_item(blueprint: BlueprintEntity):
	if held_item and held_item.get_parent() == _mask:
		_mask.remove_child(held_item)

	held_item = blueprint

	if held_item:
		_mask.add_child(held_item)
		_mask.move_child(held_item, 0)


func _update_label() -> void:
	var can_be_stacked := held_item and held_item.stack_count > 1

	if can_be_stacked:
		_lable.text = str(held_item.stack_count)
		_lable.show()
	else:
		_lable.text = str(1)
		_lable.hide()


func _swap_item() -> void:
	var temp = held_item
	held_item = _gui.blueprint
	_gui.blueprint = temp


func _release_item() -> void:
	var temp = _gui.blueprint
	_gui.blueprint = null  # first reset to remove the parent
	held_item = temp


func _grep_item() -> void:
	var temp = held_item
	held_item = null
	_gui.blueprint = temp
