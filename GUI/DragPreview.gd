class_name DragPreview
extends Control

enum PositionMode { NORMAL, SNAP }

var position_mode := PositionMode.NORMAL
var blueprint: BlueprintEntity:
	set = _set_blueprint,
	get = _get_blueprint

var _mouse_grid_pos = Vector2.ZERO
var _panel_reference: InventoryPanel

@onready var _label: Label = $CanvasLayer/Label
@onready var _preview: Node = $CanvasLayer/Preview


func _ready():
	Events.mouse_grid_position.connect(_on_mouse_grid_position)


func _input(event):
	if event is InputEventMouseMotion:
		global_position = (
			(get_viewport().get_screen_transform().affine_inverse() * event.global_position).floor()
		)
	elif event.is_action_pressed("rotate_blueprint"):
		if blueprint != null and blueprint.rotateable:
			_preview.global_rotation_degrees += 90


func _process(_delta):
	if _preview == null:
		pass
	elif position_mode == PositionMode.NORMAL:
		_preview.position = Vector2.ZERO
	elif position_mode == PositionMode.SNAP:
		_preview.global_position = _mouse_grid_pos

	_update_label()


func destroy_blueprint() -> void:
	_panel_reference = null
	for child in _preview.get_children():
		child.queue_free()

	SoundManager.play("drag_preview_disabled")


func on_panel_clicked(panel: InventoryPanel):
	var has_item = blueprint != null
	var has_panel_item = panel.held_item != null
	var is_valid_item = Library.is_valid_item(blueprint, panel.item_filter)

	if has_panel_item:
		_panel_reference = panel

		for child in _preview.get_children():
			child.queue_free()

		for child in blueprint.get_children():
			_preview.add_child(child.duplicate())

	elif has_item and not has_panel_item and is_valid_item:
		destroy_blueprint()


func _on_mouse_grid_position(pos: Vector2):
	_mouse_grid_pos = pos


func _set_blueprint(_entity: BlueprintEntity):
	pass


func _get_blueprint() -> BlueprintEntity:
	if _panel_reference == null:
		return null
	return _panel_reference.held_item


func _update_label() -> void:
	var can_be_stacked := blueprint != null and blueprint.stack_count > 1

	if can_be_stacked:
		_label.text = str(blueprint.stack_count)
		_label.show()
	else:
		_label.text = str(1)
		_label.hide()
