extends Control

@onready var _start_button: Button = $VBoxContainer/StartButton
@onready var _quit_button: Button = $VBoxContainer/QuitButton


func _ready():
	_start_button.pressed.connect(_on_start_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://PlanetSelection.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
