class_name ScoreUI
extends MarginContainer

const SCORE_POWER_FACTOR = 1000

var _power := 0
var _score: int = 0:
	set = _set_score

@onready var _label: Label = $PanelContainer/MarginContainer/HBoxContainer/Label


func _ready():
	Events.power_produced.connect(_on_power_produced)

	_score = 0


func _on_power_produced(amount):
	_power += amount
	_score = (_power / SCORE_POWER_FACTOR)


func _set_score(value):
	_score = value
	_label.text = str(value)
