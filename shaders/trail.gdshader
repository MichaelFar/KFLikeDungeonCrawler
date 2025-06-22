shader_type spatial;
render_mode blend_mix, cull_disabled, unshaded;

uniform bool alpha_override = false;
uniform vec4 new_color : source_color;
void fragment() {
    float edge_fade = 1.0 - length(UV * 2.0 - 1.0);
    
    float wave = sin(2.0 + UV.x * 3.0) * 0.5 + 0.5;
    
    float alpha = edge_fade * wave;
    alpha = smoothstep(0.0, 0.8, alpha);
    
    float flicker = sin(5.0 + UV.y * 10.0) * 0.1 + 0.8;
    
    ALPHA = alpha * flicker * 3.0;
    if(alpha_override)
	{
		ALPHA = 0.0;
	}
    ALBEDO = new_color.rgb;
    //EMISSION = base_color * (wave * 0.5 + 0.5);
}
