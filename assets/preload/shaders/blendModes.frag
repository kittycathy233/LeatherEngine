#pragma header

uniform sampler2D camera;

void main() {
  vec4 color = flixel_texture2D(camera, openfl_TextureCoordv);
	ofl_FragColor = color;
}

