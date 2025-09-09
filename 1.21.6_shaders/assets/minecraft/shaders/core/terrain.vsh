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
out vec4 lightMapColor; // Added missing output

#moj_import <light_sample.glsl>
