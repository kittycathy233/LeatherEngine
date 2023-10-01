#pragma header

void main() {

  vec4 col = flixel_texture2D(bitmap, openfl_TextureCoordv);
  
  const vec3 target = vec3(0.0, 1.0, 0.0); // Find green
  const vec3 replace = vec3(1.0, 0.0, 0.0); // Replace with red
  
  const float threshold = 0.5; // Controls target color range
  const float softness = 0.3; // Controls linear falloff
  
  // Get difference to use for falloff if required
  float diff = distance(col.rgb, target) - threshold;
  
  // Apply linear falloff if needed, otherwise clamp
  float factor = clamp(diff / softness, 0.0, 1.0);
  
  gl_FragColor = vec4(mix(replace, col.rgb, factor), col.a);
}