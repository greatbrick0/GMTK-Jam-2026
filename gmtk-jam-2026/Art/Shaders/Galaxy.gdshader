shader_type canvas_item;

uniform float perlinScale;
uniform vec2 scrollMod;
uniform int pixelScale;
uniform float aspectRatio = 1.778;
uniform int gradientSteps;
uniform float gradientStrength: hint_range(0.0,5.0);

uniform  sampler2D spaceLargeGradient;


vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

vec2 UVPixel(vec2 uv) {
	vec2 newUv = uv;
	newUv.x *= aspectRatio;
	newUv *= float(pixelScale);
	newUv = floor(newUv);
	newUv /= float(pixelScale);
	return newUv;
}

void fragment() {
	
	float perlinScaleMod = perlinScale * cos(TIME / 3.0);
	
	
	
	
	vec2 modUV = UVPixel(UV) * perlinScale;
	modUV += TIME * scrollMod;
	float perlin = noise(modUV);
	float perlin2 = mix(0, noise(UVPixel(UV) * PI), perlin);
	float perlinStepped = floor(perlin2 * float(gradientSteps));
	perlinStepped /= float(gradientSteps);
	perlinStepped /= gradientStrength;
	
	vec4 perlinSample = texture(spaceLargeGradient, vec2(perlinStepped));
	
	//if (perlinStepped > 0.0)
	//	COLOR = perlinSample;
	if (perlinStepped > 0.0)
		COLOR = mix(texture(TEXTURE,UV),perlinSample,perlinStepped);
	
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
