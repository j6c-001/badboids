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

#define OCTAVES 6
float fbm(in vec2 uv)
{
    float value = 0.;
    float amplitude = .5;

    for (int i = 0; i < OCTAVES; i++)
    {
        value += noise(uv) * amplitude;

        amplitude *= .5;

        uv *= 2.;
    }

    return value;
}


float sphIntersect( vec3 ro, vec3 rd, vec4 sph )
{
    vec3 oc = ro - sph.xyz;
    float b = dot( oc, rd );
    float c = dot( oc, oc ) - sph.w*sph.w;
    float h = b*b - c;
    if( h<0.0 ) return -1.0;
    h = sqrt( abs(h) ) * sign(h);
    return -b - h;
}
vec3 Sky(in vec3 ro, in vec3 rd)
{


    // Calculate sky plane
    float dist = sphIntersect(ro, rd, vec4(0,5000,0,5000));
    vec2 p = (ro + dist * rd).xz / 50.f;

    // from iq's shader, https://www.shadertoy.com/view/MdX3Rr
    vec3 lightDir = normalize(vec3(-.8, .15, -.3));
    float sundot = clamp(dot(rd, lightDir), 0.0, 1.0);

    vec3 cloudCol = vec3(1.);
    //vec3 skyCol = vec3(.6, .71, .85) - rd.y * .2 * vec3(1., .5, 1.) + .15 * .5;
    vec3 skyCol = vec3(0.3,0.5,0.85) - rd.y*rd.y*0.5;
    skyCol = mix( skyCol, 0.85 * vec3(0.7,0.75,0.85), pow( 1.0 - max(rd.y, 0.0), 4.0 ) );

    // sun
    vec3 sun = 0.25 * vec3(1.0,0.7,0.4) * pow( sundot,5.0 );
    sun += 0.25 * vec3(1.0,0.8,0.6) * pow( sundot,64.0 );
    sun += 0.2 * vec3(1.0,0.8,0.6) * pow( sundot,512.0 );
    skyCol += sun;

    // clouds
    float t = iTime * 0.1;
    float den = fbm(p+t);
    skyCol = mix( skyCol, cloudCol, smoothstep(.4, .8, den));

    return skyCol;
}

mat3 setCamera( in vec3 ro, in vec3 ta, float cr )
{
    vec3 cw = normalize(ta-ro);
    vec3 cp = vec3(sin(cr), cos(cr),0.0);
    vec3 cu = normalize( cross(cw,cp) );
    vec3 cv = normalize( cross(cu,cw) );
    return mat3( cu, cv, cw );
}

void main()
{
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord.xy / iResolution.xy;
    uv -= 0.5;
    uv.x *= iResolution.x / iResolution.y;
    uv.y = 1 - uv.y;


    vec3 ro =  camera;
    vec3 ta =  target;
    mat3 cam = setCamera(ro, ta, 0.0);
    vec3 rd = normalize(cam * vec3(uv, 1.0));

    vec3 col = Sky(ro, rd);

    fragColor = vec4(vec3(col),1.0);
}