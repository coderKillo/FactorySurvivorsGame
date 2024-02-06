extends Node

const OFFSET = [0.2, 0.4, 0.6, 0.8]

var RecolorShader := preload("res://Shader/recolor_shader.gdshader")

var _color_table: Dictionary


func _ready():
	_load_color_table()


func create_recolor_material_from(color_name: String) -> ShaderMaterial:
	if color_name not in _color_table:
		return null

	var material = ShaderMaterial.new()
	material.shader = RecolorShader
	material.set_shader_parameter("palette", _get_color_platte_from(color_name))

	return material


func _get_color_platte_from(color_name: String) -> GradientTexture1D:
	if color_name not in _color_table:
		return null
	return _color_table[color_name]


func _load_color_table() -> void:
	var table: ColorTable = preload("res://Systems/color_table.tres")

	for color_name in table.colors.keys():
		var colors = table.colors[color_name]
		var palette = GradientTexture1D.new()
		palette.gradient = Gradient.new()
		palette.gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
		for i in len(OFFSET):
			palette.gradient.add_point(OFFSET[i], colors[i])

		_color_table[color_name] = palette


func _gradient_offset(size: int):
	var array = []
	for i in range(0, size):
		array.append(i / float(size))
	return array
