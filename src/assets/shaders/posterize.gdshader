shader_type spatial;
render_mode unshaded, depth_draw_always, cull_disabled;

uniform sampler2D ScreenTexture : hint_screen_texture;

// Twixel Settings
uniform float TwixelAngle : hint_range(0.0, 45.0) = 45.0;
uniform float PixelSize : hint_range(1.0, 32.0) = 5.0;

// Palette Settings
uniform bool Quantize = true;
uniform sampler2D PaletteTexture : source_color;

// Posterize Settings
uniform bool Posterize = true;
uniform int ColorSteps : hint_range(2, 16) = 16;

void vertex() {
	POSITION = vec4(VERTEX.xy * 2.0, 1.0, 1.0);
}

vec3 quantized_color(vec3 original_color) {
	ivec2 palette_size = textureSize(PaletteTexture, 0);
	vec3 quantized_color = vec3(0.0, 1.0, 0.0);
	float min_dist = 9999.0;

	for (int y = 0; y < palette_size.y; y++) {
		for (int x = 0; x < palette_size.x; x++) {
			vec2 palette_uv = (vec2(float(x), float(y)) + 0.5) / vec2(palette_size);
			vec3 palette_color = textureLod(PaletteTexture, palette_uv, 0.0).rgb;
			float dist = distance(original_color, palette_color);
			if (dist < min_dist) {
				min_dist = dist;
				quantized_color = palette_color;
			}
		}
	}
	return quantized_color;
}

vec3 posterize_color(vec3 color, int steps) {
	return floor(color * float(steps)) / float(steps);
}

void fragment() {
	vec2 frag_coord = FRAGCOORD.xy;
	vec2 screen_pixel_size = 1.0 / VIEWPORT_SIZE;

	float aRad = radians(TwixelAngle);
	mat2 rotation = mat2(
		vec2(cos(aRad), -sin(aRad)),
		vec2(sin(aRad),  cos(aRad))
	);

	vec2 rotated_coord = rotation * frag_coord;
	vec2 pixelated_coord = round(rotated_coord / PixelSize) * PixelSize;
	vec2 final_coord = transpose(rotation) * pixelated_coord;
	final_coord = clamp(final_coord, vec2(1.0), VIEWPORT_SIZE - vec2(1.0));

	vec3 color = textureLod(ScreenTexture, final_coord * screen_pixel_size, 0.0).rgb;

	if (Posterize) {
		color = posterize_color(color, ColorSteps);
	}

	if (Quantize) {
		color = quantized_color(color);
	}

	// Remove blue-ish tones
	if (color.b > color.r + 0.1 && color.b > color.g + 0.1) {
		ALBEDO = vec3(0.0); // set to black
	} else {
		ALBEDO = color;
	}
}
