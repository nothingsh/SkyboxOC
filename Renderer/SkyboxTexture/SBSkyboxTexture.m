//
//  SBSkyboxTexture.m
//  SkyboxOC
//
//  Created by Wynn Zhang on 12/10/23.
//

#import "SBSkyboxTexture.h"

@implementation SBSkyboxTexture

-(nonnull instancetype)initWithDevice:(id<MTLDevice>)device images:(NSArray<NSString *> *)images
{
    NSImage* sampleImage = [NSImage imageNamed:images[0]];
    NSInteger width = sampleImage.size.width;
    NSInteger height = sampleImage.size.height;
    MTLTextureDescriptor *descriptor = [MTLTextureDescriptor textureCubeDescriptorWithPixelFormat:MTLPixelFormatRGBA8Unorm size:width mipmapped:true];
    _texture = [device newTextureWithDescriptor:descriptor];
    
    MTLRegion region = {{ 0, 0, 0 }, {width, height, 1}};
    for (int i=0; i<images.count; i++) {
        NSImage* image = (i == 0) ? sampleImage : [NSImage imageNamed:images[i]];
        // Turn NSImage into CGImage
        NSData *imageData = [image TIFFRepresentation];
        CFDataRef dataRef = (__bridge CFDataRef)imageData;
        CGImageSourceRef sourceRef = CGImageSourceCreateWithData(dataRef, NULL);
        CGImageRef spriteImage = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
        // Get Image Bitmap Data
        size_t width = CGImageGetWidth(spriteImage);
        size_t height = CGImageGetHeight(spriteImage);
        Byte *spriteData = (Byte *) calloc(width * height * 4, sizeof(Byte));
        CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
        CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
        // Release memory
        CGContextRelease(spriteContext);
        
        if (spriteData)
        {
            [_texture replaceRegion:region
                       mipmapLevel:0
                             slice:i
                         withBytes:spriteData
                       bytesPerRow:width * 4
                     bytesPerImage:width * height * 4
            ];
        }
        free(spriteData);
        spriteData = NULL;
        CGImageRelease(spriteImage);
        CFRelease(sourceRef);
    }
    
    return self;
}

@end
