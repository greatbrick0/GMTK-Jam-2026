shader_type canvas_item;

uniform sampler2D lightMask;
uniform sampler2D unlitVisuals;
uniform vec4 darknessColour : source_color = vec4(0, 0, 0, 1);

void vertex() {
	
}

void fragment() {
	COLOR = texture(unlitVisuals, UV);
	float litStrength = clamp(texture(lightMask, UV).g, 0.0, 1.0);
	float luminence = dot(COLOR.rgb, vec3(0.299, 0.587, 0.114));
	float adjustedLum = 2.0 * pow(luminence, 1.5);
	COLOR.rgb = mix(darknessColour.rgb * adjustedLum, COLOR.rgb, litStrength);
	COLOR = mix(darknessColour, COLOR, max(litStrength, 0.5));
	//COLOR = mix(COLOR, texture(lightMask, UV), sin(TIME)); //debug
}
