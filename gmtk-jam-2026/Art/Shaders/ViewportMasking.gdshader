shader_type canvas_item;

uniform sampler2D lightMask;
uniform sampler2D unlitVisuals;
uniform float threshold: hint_range(0.0,1.0);
uniform vec4 darknessColour : source_color = vec4(0, 0, 0, 1);

void vertex() {
	
}

void fragment() {
	COLOR = texture(unlitVisuals, UV);
	float litStrength = clamp(texture(lightMask, UV).r, 0.0, 1.0);
	vec4 litImpact = vec4(1,1,1,1);
	COLOR = mix(darknessColour, COLOR, litStrength);
	//litImpact = mix(darknessImpact, litImpact, litStrength);
	//COLOR *= litImpact;
}
