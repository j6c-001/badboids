#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

layout(location = 0) out vec4 fragColor;

uniform vec2 iResolution;
uniform float iTime;
uniform vec3 camera;
uniform vec3 target;
uniform vec3 sound;

float random(in vec2 uv)
{
  return fract(sin(dot(uv.xy,
  vec2(12.9898,78.233)))*
  43758.5453123);
}

float noise(in vec2 uv)
{
  vec2 i = floor(uv);
  vec2 f = fract(uv);
  f = f * f * (3. - 2. * f);

  float lb = random(i + vec2(0., 0.));
  float rb = random(i + vec2(1., 0.));
  float lt = random(i + vec2(0., 1.));
  float rt = random(i + vec2(1., 1.));

  return mix(mix(lb, rb, f.x),
  mix(lt, rt, f.x), f.y);
}

void main() {
  vec2 uv = (FlutterFragCoord().xy - iResolution.xy * 0.5) / iResolution.y;
  float n =noise(vec2(iTime)) ;
  float l  = length(uv);
  fragColor = 0.4* vec4((0.5* sound.z*(sound.x+sound.y))+n*n,n*.1,l*l,  1);
}
