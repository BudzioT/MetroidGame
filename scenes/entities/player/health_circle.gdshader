shader_type canvas_item;

// Center of the circle
uniform vec2 center = vec2(0.5, 0.5);
// Radius of it
uniform float radius: hint_range(0.0, 1.0) = 0.3;
// Width of the circle 
uniform float width: hint_range(0.0, 1.0) = 0.2;

// Its color
uniform vec3 color: source_color = vec3(1.0);
// Alpha of it
uniform float alpha: hint_range(0.0, 1.0) = 1.0;

// Progress of the circle
uniform float progress: hint_range(0.0, 1.0) = 1.0;

// Fragment shader
void fragment() {
	// Make an outer circle and the inner one
	float outer_circle = step(distance(center, UV), radius);
	float inner_circle = step(distance(center, UV), radius - width);
	
	// Cut out of the circle
	float cutOut = step((1.0 - progress) * TAU, atan(UV.x - center.x, UV.y - center.y) + PI);
	
	// Create the health circle by deleting the inner part
	COLOR.a = (outer_circle - inner_circle) * alpha * cutOut;
	
	// Set the circle filling color
	COLOR.rgb = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
