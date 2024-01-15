class_name DragPreview
extends Control

enum PositionMode { NORMAL, SNAP }

var position_mode := PositionMode.NORMAL
var blueprint: BlueprintEntity:
	set = _set_blueprint

var _mouse_grid_pos = Vector2.ZERO

@onready var _label: Label = $Label


func _ready():
	Events.mouse_grid_position.connect(_on_mouse_grid_position)


func _input(event):
	if event is InputEventMouseMotion:
		global_position = (
			(get_viewport().get_screen_transform().affine_inverse() * event.global_position).floor()
		)


func _process(_delta):
	if blueprint == null:
		pass
	elif position_mode == PositionMode.NORMAL:
		blueprint.position = Vector2.ZERO
	elif position_mode == PositionMode.SNAP:
		blueprint.global_position = _mouse_grid_pos

	_update_label()


func destroy_blueprint() -> void:
	if blueprint:
		remove_child(blueprint)
		blueprint.queue_free()
		blueprint = null


func _on_mouse_grid_position(pos: Vector2):
	_mouse_grid_pos = pos


func _set_blueprint(entity: BlueprintEntity):
	if blueprint != null and blueprint.get_parent() == self:
		remove_child(blueprint)

	blueprint = entity
	if blueprint != null:
		add_child(blueprint)
		move_child(blueprint, 0)

	_update_label()


func _update_label() -> void:
	var can_be_stacked := blueprint != null and blueprint.stack_count > 1

	if can_be_stacked:
		_label.text = str(blueprint.stack_count)
		_label.show()
	else:
		_label.text = str(1)
		_label.hide()
