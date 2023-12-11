//
//  SBCamera.h
//  SkyboxOC
//
//  Created by Wynn Zhang on 12/10/23.
//

#ifndef SBCamera_h
#define SBCamera_h

#import <Foundation/Foundation.h>
#import <simd/simd.h>

@interface SBCamera: NSObject

- (nonnull instancetype)initWithPosition: (simd_float3)position rotation: (simd_float3)euler;
- (void)updateWithOffset: (CGSize)size;

@property(nonatomic, readonly) matrix_float4x4 viewMatrix;
@property(nonatomic, readonly) matrix_float4x4 perspectiveMatrix;

@end

#endif /* SBCamera_h */
