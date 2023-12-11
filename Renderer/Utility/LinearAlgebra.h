//
//  LinearAlgebra.h
//  SkyboxOC
//
//  Created by Wynn Zhang on 12/10/23.
//

#ifndef LinearAlgebra_h
#define LinearAlgebra_h

#import <stdlib.h>
#import <simd/simd.h>

matrix_float4x4 identity(void);

matrix_float4x4 translate(vector_float3 translation);

matrix_float4x4 rotate(vector_float3 rotation);

matrix_float4x4 perspective_projection(float fovy, float aspect, float near, float far);

#endif /* LinearAlgebra_h */
