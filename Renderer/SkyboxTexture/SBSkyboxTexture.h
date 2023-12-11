//
//  SBSkyboxTexture.h
//  SkyboxOC
//
//  Created by Wynn Zhang on 12/10/23.
//

#ifndef SBSkyboxTexture_h
#define SBSkyboxTexture_h

@import MetalKit;

@interface SBSkyboxTexture : NSObject

-(nonnull instancetype)initWithDevice:(id<MTLDevice>_Nonnull) device images:(NSArray<NSString *>*_Nonnull) images;

@property(nonatomic, readonly) id<MTLTexture> _Nonnull texture;

@end

#endif /* SBSkyboxTexture_h */
