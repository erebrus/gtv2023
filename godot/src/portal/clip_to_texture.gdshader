shader_type canvas_item;

uniform sampler2D image: source_color;

void fragment() {
	vec4 orig = texture(image, SCREEN_UV);
	vec4 mask = texture(TEXTURE, UV);
	COLOR.a = mask.a; 
	COLOR.rgb = orig.rgb;
}
