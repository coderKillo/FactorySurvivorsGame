class_name Entity
extends Node2D


func _setup(_blueprint):
	pass


func _setup_gui(_gui):
	for child in get_children():
		if child.has_method("setup_gui"):
			child.setup_gui(_gui)


func _show_gui():
	for child in get_children():
		if child.has_method("show_gui"):
			child.show_gui()


func _hide_gui():
	for child in get_children():
		if child.has_method("hide_gui"):
			child.hide_gui()