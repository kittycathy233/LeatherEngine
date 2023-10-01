package shaders;

import flixel.system.FlxAssets.FlxShader;

/**
 * Port of https://www.shadertoy.com/view/sslyDB
 */
class ColorSwap {
	public var shader(default, null):ColorSwapShader = new ColorSwapShader();
	public var r(default, set):Float = 255;
	public var g(default, set):Float = 0;
	public var b(default, set):Float = 0;

	private function set_r(value:Float) {
		r = value;
		shader.red.value = [r];
		return r;
	}

	private function set_g(value:Float) {
		g = value;
		shader.green.value = [g];
		return g;
	}

	private function set_b(value:Float) {
		b = value;
		shader.blue.value = [b];
		return b;
	}

	public function new() {
		r = 255;
		g = 0;
		b = 0;
	}
}

class ColorSwapShader extends FlxShader {
	@:glFragmentSource('
	#pragma header

	uniform float red;
	uniform float green;
	uniform float blue;

	void main() {
	
	  vec4 col = flixel_texture2D(bitmap, openfl_TextureCoordv);
	  
	  const vec3 target = vec3(1.0, 0.0, 0.0); // Find red
	  vec3 replace = vec3(red / 255.0, green / 255.0, blue / 255.0); // Replace with color
	  
	  const float threshold = 0.75; // Controls target color range
	  const float softness = 0.3; // Controls linear falloff
	  
	  // Get difference to use for falloff if required
	  float diff = distance(col.rgb, target) - threshold;
	  
	  // Apply linear falloff if needed, otherwise clamp
	  float factor = clamp(diff / softness, 0.0, 1.0);
	  
	  gl_FragColor = vec4(mix(replace, col.rgb, factor), col.a);
	}')
	public function new() {
		super();
	}
}
