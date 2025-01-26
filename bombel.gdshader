shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;


uniform vec3 colour : source_color;
uniform vec3 colour2 : source_color;


void fragment() {
	vec4 n_out22p0 = vec4(0.000000, 0.000000, 0.000000, 1.000000);
	vec3 n_out35p0 = VIEW;
	float n_in21p3 = 2.00000;
	float n_out21p0 = pow(1.0 - clamp(dot(NORMAL, n_out35p0), 0.0, 1.0), n_in21p3);
	vec3 n_out24p0 = mix(vec3(n_out22p0.xyz), vec3(colour.xyz), vec3(n_out21p0));
	vec4 n_out25p0 = vec4(0.000000, 0.000000, 0.000000, 1.000000);
	vec4 n_out27p0 = vec4(1.000000, 1.000000, 1.000000, 1.000000);
	float n_in28p3 = 0.80000;
	float n_out28p0 = pow(1.0 - clamp(dot(NORMAL, n_out35p0), 0.0, 1.0), n_in28p3);
	vec3 n_out26p0 = mix(vec3(n_out25p0.xyz), vec3(n_out27p0.xyz), vec3(n_out28p0));
	vec3 n_out29p0 = mix(n_out24p0, colour2, n_out26p0);
	vec4 n_out32p0 = vec4(0.000000, 0.000000, 0.000000, 1.000000);
	vec4 n_out33p0 = vec4(1.000000, 1.000000, 1.000000, 1.000000);
	float n_in34p3 = 0.30000;
	float n_out34p0 = pow(1.0 - clamp(dot(NORMAL, n_out35p0), 0.0, 1.0), n_in34p3);
	vec3 n_out31p0 = mix(vec3(n_out32p0.xyz), vec3(n_out33p0.xyz), vec3(n_out34p0));
	ALBEDO = n_out29p0;
	ALPHA = n_out31p0.x;
	EMISSION = n_out29p0;
}
