shader_type canvas_item;

uniform vec4 flash_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float flash_modifier = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
	COLOR = flash_color;
}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR = flash_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
