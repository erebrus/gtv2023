shader_type canvas_item;

uniform vec4 color:source_color;


void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(color.rgb, previous_color.a);
	vec4 new_color = previous_color;
	if (COLOR.a < .5f)
	{
		new_color = white_color;
	}
	COLOR = new_color;
}