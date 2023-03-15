#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

layout(location = 0) out vec4 fragColor;
uniform vec2 dim;
uniform float iTime;
uniform vec3 bmh;


vec3 flutterNavy = vec3(4, 43, 89) / 255;
vec3 flutterBlue = vec3(5, 83, 177) / 255;
vec4 flutterSky = vec4(2, 125, 253,255) / 255;

void main() {
  vec2 p = FlutterFragCoord().xy/dim;
  vec2 q = p - vec2(0.5, 0.5);

  vec4 col = vec4(bmh *p.xyx, bmh.z);

  float r = bmh.z + 1 * sin(iTime) * cos(atan(q.x, q.y) *  ( 3 * bmh.y + 3 * bmh.x + 3*  bmh.z));

  col *= r* length(q);

  fragColor =col;
}