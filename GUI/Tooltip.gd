class_name Tooltip
extends Control


func _input(event):
	if event is InputEventMouseMotion:
		global_position = get_global_mouse_position()


func _ready():
	$PanelContainer.hide()


func show_tooltip(text: String) -> void:
	$PanelContainer.show()

	%TooltipLabel.text = text


func hide_tooltip() -> void:
	$PanelContainer.hide()