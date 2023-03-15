#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

layout(location = 0) out vec4 fragColor;
layout(location = 0) uniform vec2 dim;

vec3 flutterNavy = vec3(4, 43, 89) / 255;
vec3 flutterBlue = vec3(5, 83, 177) / 255;
vec4 flutterSky = vec4(2, 125, 253,255) / 255;

void main() {
  vec2 st = FlutterFragCoord().xy;
  //fragColor = flutterSky;
}