#ifndef _LIGHTMAPSAMPLE_GLSL
#define _LIGHTMAPSAMPLE_GLSL

void main() {
    vec3 pos = Position + ModelOffset;
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    sphericalVertexDistance = fog_spherical_distance(pos);
    cylindricalVertexDistance = fog_cylindrical_distance(pos);

    // Properly convert UV2 to float and divide
    vec2 uv2f = vec2(UV2) / 16.0;
    lightMapColor = texelFetch(Sampler2, ivec2(uv2f), 0);
    // Lightmap changes depending on the dimension
    vec4 targetColor = vec4(229.0 / 255.0, 229.0 / 255.0, 229.0 / 255.0, 1.0);
    float tolerance = 0.001;
    if (all(lessThan(abs(Color - targetColor), vec4(tolerance)))) { // if nether
        vertexColor = Color * lightMapColor;
        vertexColor *= 1.100436681222707;
    } else {  // if overworld or end
        vertexColor = Color * lightMapColor;
    }

    texCoord0 = UV0;
}
#endif // _LIGHTMAPSAMPLE_GLSL