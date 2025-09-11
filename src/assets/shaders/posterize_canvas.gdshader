shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture;

uniform float exposure    : hint_range(0.5, 2.0) = 1.0;
uniform float contrast    : hint_range(0.5, 2.0) = 1.05;
uniform float saturation  : hint_range(0.0, 2.0) = 0.9;

uniform bool  enable_pixelate = true;
uniform float pixel_factor    : hint_range(0.5, 6.0) = 2.0;

uniform bool  enable_posterize = true;
uniform float color_levels     : hint_range(2.0, 16.0) = 8.0;
uniform float dither_strength  : hint_range(0.0, 1.0) = 0.35;

uniform float chrom_aberration : hint_range(0.0, 2.0) = 0.35;
uniform float vignette_strength: hint_range(0.0, 2.0) = 1.0;
uniform float grain_strength   : hint_range(0.0, 1.0) = 0.2;

uniform vec3  tint_color = vec3(0.95, 1.03, 0.9);
uniform float tint_strength : hint_range(0.0, 1.0) = 0.15;

uniform vec2  viewport_size_override = vec2(0.0);

uniform bool overlay_enable;
uniform vec4 overlay_color : source_color;

vec4 overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

float bayer4x4(vec2 p){
    int x = int(mod(p.x, 4.0));
    int y = int(mod(p.y, 4.0));
    int m[16] = int[16](
        0,  8,  2, 10,
       12,  4, 14,  6,
        3, 11,  1,  9,
       15,  7, 13,  5
    );
    return (float(m[y*4 + x]) + 0.5) / 16.0;
}

vec3 to_hsv(vec3 c){
    float cmax = max(c.r, max(c.g, c.b));
    float cmin = min(c.r, min(c.g, c.b));
    float d = cmax - cmin;
    float h = 0.0;
    if (d > 1e-5) {
        if      (cmax == c.r) h = mod((c.g - c.b) / d, 6.0);
        else if (cmax == c.g) h = (c.b - c.r) / d + 2.0;
        else                  h = (c.r - c.g) / d + 4.0;
        h /= 6.0;
        if (h < 0.0) h += 1.0;
    }
    float s = cmax <= 1e-5 ? 0.0 : d / cmax;
    float v = cmax;
    return vec3(h, s, v);
}

vec3 to_rgb(vec3 hsv){
    float h = hsv.x * 6.0;
    float s = hsv.y;
    float v = hsv.z;
    int i = int(floor(h));
    float f = h - float(i);
    float p = v * (1.0 - s);
    float q = v * (1.0 - s * f);
    float t = v * (1.0 - s * (1.0 - f));
    if(i == 0) return vec3(v, t, p);
    if(i == 1) return vec3(q, v, p);
    if(i == 2) return vec3(p, v, t);
    if(i == 3) return vec3(p, q, v);
    if(i == 4) return vec3(t, p, v);
    return vec3(v, p, q);
}

float luma(vec3 c){ return dot(c, vec3(0.2126, 0.7152, 0.0722)); }

vec3 adjust_contrast_saturation(vec3 c, float contrast_, float saturation_){
    c = (c - 0.5) * contrast_ + 0.5;
    vec3 hsv = to_hsv(c);
    hsv.y *= saturation_;
    return clamp(to_rgb(hsv), 0.0, 1.0);
}

void fragment(){
    vec2 uv = SCREEN_UV;

    vec2 px = SCREEN_PIXEL_SIZE;
    if (viewport_size_override.x > 0.0 && viewport_size_override.y > 0.0){
        px = 1.0 / viewport_size_override;
    }

    if (enable_pixelate){
        vec2 step_uv = px * pixel_factor;
        uv = floor(uv / step_uv) * step_uv + step_uv * 0.5;
    }

    vec2 center = vec2(0.5);
    vec2 dir = uv - center;
    float dist = length(dir);
    float ca = chrom_aberration * dist * dist;

    vec3 col;
    col.r = texture(screen_tex, uv + dir * ( ca)).r;
    col.g = texture(screen_tex, uv                    ).g;
    col.b = texture(screen_tex, uv - dir * ( ca)).b;

    col *= exposure;

    col = mix(col, col * tint_color, tint_strength);

    if (enable_posterize){
        vec2 frag_xy = floor(uv / px);
        float b = bayer4x4(frag_xy);

        vec3 q = floor(col * color_levels + b * dither_strength);
        col = q / (color_levels - 1.0);
    }

    col = adjust_contrast_saturation(col, contrast, saturation);

    float vignette = smoothstep(0.5, 0.9, dist) * vignette_strength;
    col *= clamp(1.0 - vignette, 0.0, 1.0);

    float n = fract(sin(dot(floor(uv/px), vec2(12.9898, 78.233)) + TIME * 37.0) * 43758.5453);
    col += (n - 0.5) * (px.x + px.y) * 2.0 * grain_strength;

	vec4 result = vec4(clamp(col, 0.0, 1.0), 1.0);
	vec4 overlay_result = overlay(result, overlay_color);
	COLOR = mix(result, overlay_result, float(overlay_enable));
}
