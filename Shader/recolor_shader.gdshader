
shader_type canvas_item;

uniform sampler2D palette;


void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 result_color = texture(palette, color.rg);
	result_color.a = color.a;
	COLOR = result_color;
}