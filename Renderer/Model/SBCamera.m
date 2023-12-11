//
//  SBCamera.m
//  SkyboxOC
//
//  Created by Wynn Zhang on 12/10/23.
//

#import "SBCamera.h"
#import "LinearAlgebra.h"

@implementation SBCamera 
{
    vector_float3 _position;
    vector_float3 _eulers;
}

- (nonnull instancetype)initWithPosition:(simd_float3)position rotation:(simd_float3)euler {
    _position = position;
    _eulers = euler;
    _perspectiveMatrix = perspective_projection(45, 800/600, 0.1, 100);
    
    return self;
}

- (void)updateWithOffset:(CGSize)size {
    float dTheta = size.width;
    float dPhi = size.height;
    
    _eulers.y += 0.01 * dTheta;
    _eulers.x -= 0.01 * dPhi;
}

- (matrix_float4x4)viewMatrix {
    return simd_mul(rotate(_eulers), translate(_position));
}

@end
