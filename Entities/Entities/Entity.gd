class_name Entity
extends Node2D


func _setup(_blueprint):
	pass


func _setup_gui(gui):
	for child in get_children():
		var gui_component := child as BaseGuiComponent
		if gui_component == null:
			continue

		gui_component.setup(gui)


func _show_gui():
	for child in get_children():
		var gui_component := child as BaseGuiComponent
		if gui_component == null:
			continue

		gui_component.show()


func _hide_gui():
	for child in get_children():
		var gui_component := child as BaseGuiComponent
		if gui_component == null:
			continue

		gui_component.hide()
