extends MarginContainer

@onready var _continue_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Continue
@onready var _quit_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Quit
@onready var _panel: Control = $PanelContainer

var _is_paused := false


func _ready():
	_continue_button.pressed.connect(_on_continue_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)

	_panel.hide()


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		_set_pause(not _is_paused)


func _on_continue_pressed() -> void:
	_set_pause(false)


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func _set_pause(paused: bool) -> void:
	get_tree().paused = paused
	_is_paused = paused

	if paused:
		_panel.show()
	else:
		_panel.hide()
