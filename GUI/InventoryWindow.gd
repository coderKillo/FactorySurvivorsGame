class_name InventoryWindow
extends MarginContainer

signal inventory_changed(panel, held_item)

var _gui: GUI

@onready var inventory_path = $PanelContainer/MarginContainer/Inventories
@onready var inventories := inventory_path.get_children()


func setup(gui: GUI):
	_gui = gui
	for inventory in inventories:
		inventory.setup(gui)

	# test
	inventories[0].panels[0].held_item = Library.blueprints.Smelter.instantiate()
	inventories[0].panels[1].held_item = Library.blueprints.PowerPlant.instantiate()
