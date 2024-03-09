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

signal open_entity_ui_changed(value)

var blueprint: BlueprintEntity:
	set(value):
		_drag_preview.blueprint = value
	get:
		return _drag_preview.blueprint

var preview: Sprite2D:
	get:
		return _drag_preview._preview

var open_entity_ui: BaseGuiComponent:
	set(value):
		open_entity_ui = value
		open_entity_ui_changed.emit(value)

@onready var _quickbar: Quickbar = $MarginContainer/Quickbar
@onready var _drag_preview: DragPreview = $DragPreview
@onready var _resource: ResourceUI = $ResourceUI
@onready var _upgrade_gui: UpgradeSystemUI = $UpgradeSystemGUI


func _ready():
	_quickbar.setup(self)
	_quickbar.add_entity(Library.blueprints["Wire"].instantiate())
	_quickbar.add_entity(Library.blueprints["Drill"].instantiate())
	_resource.setup(self)


func _process(_delta):
	_drag_preview.position_mode = (DragPreview.PositionMode.SNAP)


func _unhandled_input(event):
	for i in QUICKBAR_ACTIONS.size():
		if InputMap.event_is_action(event, QUICKBAR_ACTIONS[i]) and event.is_pressed():
			_simulate_input(_quickbar.panels[i])


func get_quickbar_panels() -> Array:
	return _quickbar.panels


func add_to_quickbar(entity: BlueprintEntity) -> void:
	return _quickbar.add_entity(entity)


func destroy_blueprint():
	_drag_preview.destroy_blueprint()


func display_upgrade(upgrades: Array[Upgrade], callback: Callable):
	_upgrade_gui.display_options(upgrades, callback)


func _simulate_input(panel: InventoryPanel) -> void:
	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true

	panel._gui_input(event)
