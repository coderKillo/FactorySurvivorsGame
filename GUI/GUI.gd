class_name GUI
extends CenterContainer

var blueprint: BlueprintEntity:
	set(value):
		_drag_preview.blueprint = value
	get:
		return _drag_preview.blueprint

var mouse_in_gui := false

@onready var _inventory: InventoryWindow = $HBoxContainer/InventoryWindow
@onready var _gui_rect: HBoxContainer = $HBoxContainer
@onready var _drag_preview = $DragPreview


func _ready():
	_inventory.setup(self)
	for inventory in _inventory.inventories:
		for panel in inventory.panels:
			panel = panel as InventoryPanel
			panel.held_item_changed.connect(_on_panel_held_item_changed)


func _process(_delta):
	mouse_in_gui = _gui_rect.get_global_rect().has_point(get_global_mouse_position())
	_drag_preview.position_mode = (
		DragPreview.PositionMode.NORMAL if mouse_in_gui else DragPreview.PositionMode.SNAP
	)


func _unhandled_input(event):
	if event.is_action_pressed("toggle_inventory"):
		_inventory.visible = not _inventory.visible


func destroy_blueprint():
	_drag_preview.destroy_blueprint()


func _on_panel_held_item_changed(panel, held_item):
	pass
