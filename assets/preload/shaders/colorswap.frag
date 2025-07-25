#pragma header

uniform vec3 uTime;
uniform bool awesomeOutline;

const float offset = 1.0 / 128.0;
vec3 normalizeColor(vec3 color)
{
	return vec3(
		color[0] / 255.0,
		color[1] / 255.0,
		color[2] / 255.0
	);
}

vec3 rgb2hsv(vec3 c)
{
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
	vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

	vec4 swagColor = vec4(rgb2hsv(vec3(color[0], color[1], color[2])), color[3]);

	// [0] is the hue???
	swagColor[0] = swagColor[0] + uTime[0];
	swagColor[1] = swagColor[1] + uTime[1];
	swagColor[2] = swagColor[2] * (1.0 + uTime[2]);
			
	if(swagColor[1] < 0.0)
	{
		swagColor[1] = 0.0;
	}
	else if(swagColor[1] > 1.0)
	{
		swagColor[1] = 1.0;
	}

	color = vec4(hsv2rgb(vec3(swagColor[0], swagColor[1], swagColor[2])), swagColor[3]);

	if (awesomeOutline)
	{
		// Outline bullshit?
		vec2 size = vec2(3, 3);

		if (color.a <= 0.5) {
			float w = size.x / openfl_TextureSize.x;
			float h = size.y / openfl_TextureSize.y;
					
			if (flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x + w, openfl_TextureCoordv.y)).a != 0.
			|| flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x - w, openfl_TextureCoordv.y)).a != 0.
			|| flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y + h)).a != 0.
			|| flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y - h)).a != 0.)
				color = vec4(1.0, 1.0, 1.0, 1.0);
		}
	}
	ofl_FragColor = color;
}