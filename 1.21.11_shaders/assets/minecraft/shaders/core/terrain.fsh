#version 460

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:chunksection.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

vec4 sampleNearest(sampler2D sampler, vec2 uv, vec2 pixelSize) {
    // Convert UV to texel space
    vec2 texelPos = uv / pixelSize;
    
    // Force exact pixel boundaries by rounding to nearest texel
    vec2 texelCenter = floor(texelPos);
    
    // Convert back to UV space, ensuring we hit exact texel centers
    vec2 snappedUV = texelCenter * pixelSize;
    
    // Use texelFetch for perfect pixel sampling if possible, otherwise fall back to texture
    ivec2 texSize = textureSize(sampler, 0);
    ivec2 texel = ivec2(texelCenter);
    
    if (all(greaterThanEqual(texel, ivec2(0))) && all(lessThan(texel, texSize))) {
        return texelFetch(sampler, texel, 0);
    }
    
    // Force nearest neighbor sampling by using texture with snapped UVs
    return texture(sampler, snappedUV);
}

void main() {
    vec4 color = sampleNearest(Sampler0, texCoord0, 1.0f / TextureSize) * vertexColor;
    color = mix(FogColor * vec4(1, 1, 1, color.a), color, ChunkVisibility);
#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
