class_name Quickbar
extends InventoryBar


func _make_panels():
	for i in slot_count:
		var panel := InventoryPanelScene.instantiate()
		add_child(panel)

		var inventory_panel: InventoryPanel = panel.get_node("InventoryPanel")
		var label: Label = panel.get_node("Label")

		panels.append(inventory_panel)

		var index := wrapi(i + 1, 0, slot_count)
		label.text = str(index)

	# test
	panels[0].held_item = Library.blueprints.Wire.instantiate()
	panels[0].held_item.stack_count = 20
	panels[1].held_item = Library.blueprints.Conveyor.instantiate()
	panels[1].held_item.stack_count = 20
