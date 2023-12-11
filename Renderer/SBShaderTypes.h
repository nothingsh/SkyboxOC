//
//  SBShaderTypes.h
//  SkyboxOC
//
//  Created by Wynn Zhang on 12/10/23.
//

#ifndef SBShaderTypes_h
#define SBShaderTypes_h

#import <simd/simd.h>

typedef struct SBVertex {
    vector_float3 position;
    vector_float3 color;
} SBVertex;

typedef struct SBCameraParameters {
    matrix_float4x4 view;
    matrix_float4x4 projection;
} SBCameraParameters;

#endif /* SBShaderTypes_h */
