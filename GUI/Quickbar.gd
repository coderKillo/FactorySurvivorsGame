class_name Quickbar
extends InventoryBar


func _make_panels():
	for i in slot_count:
		var panel := InventoryPanelScene.instantiate()
		add_child(panel)

		var inventory_panel: InventoryPanel = panel.get_node("InventoryPanel")
		var label: Label = panel.get_node("Label")

		panels.append(inventory_panel)

		var index := wrapi(i + 1, 1, slot_count)
		label.text = str(index)
