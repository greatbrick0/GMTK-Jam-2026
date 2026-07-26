shader_type canvas_item;

uniform sampler2D lightMask;
uniform sampler2D unlitVisuals;
uniform vec4 darknessColour : source_color = vec4(0, 0, 0, 1);
uniform float maximumDarknessLuminence = 0.75;
uniform float lightBandCount = 5.0;
uniform float quantizeStrength : hint_range(0.0, 1.0) = 0.25;
uniform float wobbleIntensity = 0.005;
uniform float wobbleHorizontalStrength = 5.0;

void vertex() {
	
}

void fragment() {
	float litStrength = clamp(texture(lightMask, UV).a, 0.0, 1.0);
	float quantizedLitStrength = round(smoothstep(0.0, 1.0, litStrength) * lightBandCount) / lightBandCount;
	litStrength = mix(litStrength, quantizedLitStrength, quantizeStrength);
	COLOR = texture(unlitVisuals, UV + vec2(wobbleIntensity * sin(TIME + (UV.x * wobbleHorizontalStrength)) * (1.0 - litStrength)));
	float luminence = dot(COLOR.rgb, vec3(0.299, 0.587, 0.114));
	float adjustedLum = luminence;
	adjustedLum = 2.0 * pow(luminence, 1.5);
	adjustedLum = clamp(adjustedLum, 0.0, maximumDarknessLuminence);
	COLOR.rgb = mix(darknessColour.rgb * adjustedLum, COLOR.rgb, litStrength);
	COLOR = mix(darknessColour, COLOR, max(litStrength, 0.5));
	//COLOR = mix(COLOR, texture(lightMask, UV), sin(TIME)); //debug
}
