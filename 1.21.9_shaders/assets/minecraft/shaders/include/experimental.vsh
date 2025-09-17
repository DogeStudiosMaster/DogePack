#version 460

#moj_import <fog.glsl>
#moj_import <dynamictransforms.glsl>
#moj_import <projection.glsl>
in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;
uniform sampler2D Sampler2;
out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 lightMapColor;

void main() {
    vec3 pos = Position + ModelOffset;
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    sphericalVertexDistance = fog_spherical_distance(pos);
    cylindricalVertexDistance = fog_cylindrical_distance(pos);

    vec2 uv2f = vec2(UV2) / 16.0;
    lightMapColor = texelFetch(Sampler2, ivec2(uv2f), 0);

    // Check if Color is close to #3F76E4
    vec4 colorTarget = vec4(63.0 / 255.0, 118.0 / 255.0, 228.0 / 255.0, 1.0);
    vec4 colorReplacement = vec4(77.0 / 255.0, 140.0 / 255.0, 249.0 / 255.0, 1.0);
    float colorTolerance = 0.3;

    vec4 adjustedColor = Color;
    if (all(lessThan(abs(Color - colorTarget), vec4(colorTolerance)))) {
        adjustedColor = colorReplacement;
    }

    // Lightmap logic
    vec4 netherColor = vec4(229.0 / 255.0, 229.0 / 255.0, 229.0 / 255.0, 1.0);
    float netherTolerance = 0.001;
    if (all(lessThan(abs(Color - netherColor), vec4(netherTolerance)))) {
        vertexColor = adjustedColor * lightMapColor;
        vertexColor *= (252.0 / 229.0);
    } else {
        vertexColor = adjustedColor * lightMapColor;
    }

    texCoord0 = UV0;
}
