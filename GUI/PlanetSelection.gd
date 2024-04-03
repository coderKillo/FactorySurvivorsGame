extends Control

@onready var _return_button: Button = $ReturnButton
@onready var _next_button: TextureButton = $NextButton
@onready var _previous_button: TextureButton = $PreviousButton

@onready var _planet_name: Label = $PlanetName
@onready var _planet_texture: TextureRect = $PlanetTexture
@onready var _resource_text: Label = $ResourceValueLable
@onready var _animation: AnimationPlayer = $AnimationPlayer

const DATA = [
	["Merkur", "red", [1000, 1000]],
	["Venus", "yellow", [1000, 2000]],
	["Earth", "blue", [1000, 4000]],
	["Mars", "red", [1000, 5000]],
	["Saturn", "yellow", [1000, 6000]],
]

var _current_index := 0
var _planet_base_position := Vector2.ZERO


func _ready():
	_return_button.pressed.connect(_on_return_button_pressed)
	_next_button.pressed.connect(_on_next_button_pressed)
	_previous_button.pressed.connect(_on_previous_button_pressed)

	_planet_base_position = _planet_texture.position

	_update_index()


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func _on_next_button_pressed():
	_current_index += 1
	_update_index()


func _on_previous_button_pressed():
	_current_index -= 1
	_update_index()


func _update_index():
	_previous_button.visible = _current_index > 0
	_next_button.visible = _current_index < (DATA.size() - 1)

	var planet_data = DATA[_current_index]

	_set_planet_name(planet_data[0])
	_set_resource_value(planet_data[2][0], planet_data[2][1])
	_set_planet_color(planet_data[1])

	_move_planet()


func _move_planet() -> void:
	_animation.stop()
	_animation.play("move_planet")


func _set_planet_name(planet_name: String) -> void:
	_planet_name.text = planet_name


func _set_resource_value(current_value: int, max_value: int) -> void:
	_resource_text.text = str(current_value) + "/" + str(max_value)


func _set_planet_color(color_name: String) -> void:
	_planet_texture.material.set_shader_parameter(
		"palette", RecolorTable._get_color_platte_from(color_name)
	)
