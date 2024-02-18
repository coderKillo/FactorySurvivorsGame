class_name Quickbar
extends InventoryBar

const GLOBAL_COOLDOWN = 1


func _make_panels():
	for i in slot_count:
		var panel := InventoryPanelScene.instantiate()
		add_child(panel)

		var inventory_panel: InventoryPanel = panel.get_node("InventoryPanel")
		var label: Label = panel.get_node("Label")

		panels.append(inventory_panel)

		var index := wrapi(i + 1, 0, slot_count)
		label.text = str(index)

		inventory_panel.held_item_changed.connect(_on_panel_item_changed)

	# test
	panels[0].held_item = Library.blueprints.Turret.instantiate()
	panels[1].held_item = Library.blueprints.Wire.instantiate()


func _on_panel_item_changed(_panel: InventoryPanel, _item: BlueprintEntity) -> void:
	for child in get_children():
		if child.has_method("start_cooldown"):
			child.start_cooldown(GLOBAL_COOLDOWN)
