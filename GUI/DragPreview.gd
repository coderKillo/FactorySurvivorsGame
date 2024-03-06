class_name DragPreview
extends Control

enum PositionMode { NORMAL, SNAP }

var position_mode := PositionMode.NORMAL
var blueprint: BlueprintEntity:
	set = _set_blueprint,
	get = _get_blueprint

var _mouse_grid_pos = Vector2.ZERO
var _panel_reference: InventoryPanel

@onready var _label: Label = $Label
@onready var _preview_sprite: Sprite2D = $PreviewSprite


func _ready():
	Events.mouse_grid_position.connect(_on_mouse_grid_position)


func _input(event):
	if event is InputEventMouseMotion:
		global_position = (
			(get_viewport().get_screen_transform().affine_inverse() * event.global_position).floor()
		)
	elif event.is_action_pressed("right_click"):
		destroy_blueprint()


func _process(_delta):
	if _preview_sprite == null:
		pass
	elif position_mode == PositionMode.NORMAL:
		_preview_sprite.position = Vector2.ZERO
	elif position_mode == PositionMode.SNAP:
		_preview_sprite.global_position = _mouse_grid_pos

	_update_label()


func destroy_blueprint() -> void:
	_panel_reference = null
	_preview_sprite.texture = null

	SoundManager.play("drag_preview_disabled")


func on_panel_clicked(panel: InventoryPanel):
	var has_item = blueprint != null
	var has_panel_item = panel.held_item != null
	var is_valid_item = Library.is_valid_item(blueprint, panel.item_filter)

	if not has_item and has_panel_item:
		_panel_reference = panel
		var sprite: Sprite2D = blueprint.get_node_or_null("Sprite2D")
		if sprite != null:
			_preview_sprite.texture = sprite.texture
			_preview_sprite.region_enabled = sprite.region_enabled
			_preview_sprite.region_rect = sprite.region_rect

	elif has_item and not has_panel_item and is_valid_item:
		_swap_panel_item(_panel_reference, panel)
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


func _swap_panel_item(panel1, panel2):
	var temp1 = panel1.held_item
	var temp2 = panel2.held_item
	# clear parents else add_child would fail
	panel1.held_item = null
	panel2.held_item = null
	panel1.held_item = temp2
	panel2.held_item = temp1
