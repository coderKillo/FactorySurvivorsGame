class_name Entity
extends Node2D

var value := 1

# if set to true, the EntityTracker will remove this entity
var queue_destruction := false


func _setup(_blueprint):
	pass


func _setup_gui(gui):
	var gui_component := _get_ui_component()
	if gui_component != null:
		gui_component.setup(gui)


func _show_gui():
	var gui_component := _get_ui_component()
	if gui_component != null:
		gui_component.show()


func _hide_gui():
	var gui_component := _get_ui_component()
	if gui_component != null:
		gui_component.hide()


func _get_ui_component() -> BaseGuiComponent:
	for child in get_children():
		var gui_component := child as BaseGuiComponent
		if gui_component != null:
			return gui_component

	return null
