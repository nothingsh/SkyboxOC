//
//  SBRenderer.h
//  SkyboxOC
//
//  Created by Wynn Zhang on 12/10/23.
//

#ifndef SBRenderer_h
#define SBRenderer_h

#import "SBCamera.h"
@import MetalKit;

@interface SBRenderer : NSObject<MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView camera:(SBCamera *_Nonnull)camera;

@end

#endif /* SBRenderer_h */
