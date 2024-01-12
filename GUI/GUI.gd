class_name GUI
extends CenterContainer

const QUICKBAR_ACTIONS := [
	"quickbar_1",
	"quickbar_2",
	"quickbar_3",
	"quickbar_4",
	"quickbar_5",
	"quickbar_6",
	"quickbar_7",
	"quickbar_8",
	"quickbar_9",
	"quickbar_0"
]

var blueprint: BlueprintEntity:
	set(value):
		_drag_preview.blueprint = value
	get:
		return _drag_preview.blueprint

var mouse_in_gui := false

@onready var _inventory: InventoryWindow = $HBoxContainer/InventoryWindow
@onready var _inventory_container: Container = $HBoxContainer
@onready var _quickbar: Quickbar = $MarginContainer/Quickbar
@onready var _quickbar_container: Container = $MarginContainer
@onready var _drag_preview = $DragPreview


func _ready():
	_inventory.setup(self)
	_quickbar.setup(self)


func _process(_delta):
	mouse_in_gui = _inventory_container.get_global_rect().has_point(get_global_mouse_position())

	_drag_preview.position_mode = (
		DragPreview.PositionMode.NORMAL if mouse_in_gui else DragPreview.PositionMode.SNAP
	)


func _unhandled_input(event):
	if event.is_action_pressed("toggle_inventory"):
		if _inventory.visible:
			_close_inventory()
		else:
			_open_inventory()

	else:
		for i in QUICKBAR_ACTIONS.size():
			if InputMap.event_is_action(event, QUICKBAR_ACTIONS[i]) and event.is_pressed():
				_simulate_input(_quickbar.panels[i])


func destroy_blueprint():
	_drag_preview.destroy_blueprint()


func _simulate_input(panel: InventoryPanel) -> void:
	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true

	panel._gui_input(event)


func _open_inventory() -> void:
	_quickbar_container.remove_child(_quickbar)
	_inventory.inventory_path.add_child(_quickbar)
	_inventory.visible = true


func _close_inventory() -> void:
	_inventory.inventory_path.remove_child(_quickbar)
	_quickbar_container.add_child(_quickbar)
	_inventory.visible = false
