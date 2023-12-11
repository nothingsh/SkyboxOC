//
//  LinearAlgebra.m
//  SkyboxOC
//
//  Created by Wynn Zhang on 12/10/23.
//

#import "LinearAlgebra.h"

matrix_float4x4 identity(void) {
    return (matrix_float4x4){{
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {0, 0, 0, 1}
    }};
}

matrix_float4x4 translate(vector_float3 translation) {
    return (matrix_float4x4){{
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {translation[0], translation[1], translation[2], 1}
    }};
}

matrix_float4x4 rotate(vector_float3 rotation) {
    const float alpha = rotation[0] * M_PI / 180.0;
    const matrix_float4x4 x_rotation = (matrix_float4x4) {{
        {1,            0,           0, 0},
        {0,  cosf(alpha), sinf(alpha), 0},
        {0, -sinf(alpha), cosf(alpha), 0},
        {0,            0,           0, 1}
    }};
    
    const float beta = rotation[1] * M_PI / 180.0;
    const matrix_float4x4 y_rotation = (matrix_float4x4) {{
        {cosf(beta), 0, -sinf(beta), 0},
        {         0, 1,           0, 0},
        {sinf(beta), 0,  cosf(beta), 0},
        {         0, 0,           0, 1}
    }};
    
    const float gamma = rotation[2] * M_PI / 180.0;
    const matrix_float4x4 z_rotation = (matrix_float4x4) {{
        { cosf(gamma), sinf(gamma), 0, 0},
        {-sinf(gamma), cosf(gamma), 0, 0},
        {           0,           0, 1, 0},
        {           0,           0, 0, 1}
    }};
    
    return simd_mul(simd_mul(z_rotation, y_rotation), x_rotation);
}

matrix_float4x4 perspective_projection(float fovy, float aspect, float near, float far) {
    float A = aspect * 1 / tanf(fovy * M_PI / 360);
    float B = 1 / tanf(fovy * M_PI / 360);
    float C = far / (far - near);
    float D = 1;
    float E = -near * far / (far - near);
    
    return (matrix_float4x4){{
        {A, 0, 0, 0},
        {0, B, 0, 0},
        {0, 0, C, D},
        {0, 0, E, 0}
    }};
}
