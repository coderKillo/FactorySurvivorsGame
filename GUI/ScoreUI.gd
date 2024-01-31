class_name ScoreUI
extends MarginContainer

@onready
var _total_power_label: Label = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Label
@onready
var _current_power_label: Label = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Label2


func _ready():
	Events.power_produced.connect(_on_power_produced)


func _on_power_produced(total_produced: int, produced: int, used: int):
	_total_power_label.text = str(total_produced)
	_current_power_label.text = str(used) + "/" + str(produced)
