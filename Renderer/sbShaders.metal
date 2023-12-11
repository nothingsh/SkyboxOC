//
//  sbShaders.metal
//  SkyboxOC
//
//  Created by Wynn Zhang on 12/10/23.
//

#include <metal_stdlib>
using namespace metal;

#include "SBShaderTypes.h"

struct FragmentPost {
    float4 position [[position]];
    float3 textureCoordinate;
};

vertex FragmentPost sbVertexShader (
        const device float3 *vertices [[buffer(0)]],
        unsigned int vid [[vertex_id]],
        constant SBCameraParameters &camera [[buffer(1)]])
{
    FragmentPost output;
    output.position = camera.projection * camera.view * float4(vertices[vid], 1);
    output.textureCoordinate = vertices[vid];
    return output;
}

fragment float4 sbFragmentShader (
    FragmentPost input [[stage_in]],
    texturecube<float> texture [[texture(0)]])
{
    constexpr sampler textureSampler (mag_filter::linear, min_filter::linear);
    float4 colorTex = texture.sample(textureSampler, input.textureCoordinate);
    
    return colorTex;
}
