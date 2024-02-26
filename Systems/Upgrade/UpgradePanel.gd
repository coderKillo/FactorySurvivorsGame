class_name UpgradePanel
extends PanelContainer

signal mouse_clicked

@onready var title: Label = $VBoxContainer/MarginContainer3/Label
@onready var icon: TextureRect = $VBoxContainer/MarginContainer/TextureRect
@onready var text: RichTextLabel = $VBoxContainer/MarginContainer2/RichTextLabel


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		mouse_clicked.emit()
