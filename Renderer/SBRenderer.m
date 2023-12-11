//
//  SBRenderer.m
//  SkyboxOC
//
//  Created by Wynn Zhang on 12/10/23.
//

#import "SBRenderer.h"
#import "SBShaderTypes.h"
#import "SBSkyboxTexture.h"

@implementation SBRenderer
{
    MTKView* _view;
    id<MTLDevice> _device;
    id<MTLRenderPipelineState> _renderPipeline;
    id<MTLDepthStencilState> _depthStencilState;
    id<MTLCommandQueue> _commandQueue;
    
    id<MTLBuffer> _skyboxBuffer;
    vector_uint2 _viewportSize;
    SBCamera *_camera;
    SBSkyboxTexture *_texture;
}

- (nonnull instancetype) initWithMetalKitView:(MTKView *)mtkView camera: (SBCamera *)camera
{
    self = [super init];
    if (self)
    {
        _device  = mtkView.device;
        
        id<MTLLibrary> library = [_device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"sbVertexShader"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"sbFragmentShader"];
        
        MTLRenderPipelineDescriptor *descriptor = [[MTLRenderPipelineDescriptor alloc] init];
        descriptor.label = @"Skybox Pipeline";
        descriptor.vertexFunction = vertexFunction;
        descriptor.fragmentFunction = fragmentFunction;
        descriptor.depthAttachmentPixelFormat = MTLPixelFormatDepth32Float;
        descriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        
        MTLDepthStencilDescriptor *dsDescriptor = [[MTLDepthStencilDescriptor alloc] init];
        dsDescriptor.label = @"Skybox Depth & Stencil";
        dsDescriptor.depthCompareFunction = MTLCompareFunctionLess;
        [dsDescriptor setDepthWriteEnabled:true];
        _depthStencilState = [_device newDepthStencilStateWithDescriptor:dsDescriptor];
        
        NSError *error;
        _renderPipeline = [_device newRenderPipelineStateWithDescriptor:descriptor error:&error];
        _commandQueue = [_device newCommandQueue];
        
        vector_float3 verticess[] = {
            {-1,-1,-1}, {-1,-1, 1}, {-1, 1, 1}, {-1,-1,-1}, {-1, 1, 1}, {-1, 1,-1},
            { 1, 1, 1}, { 1,-1,-1}, { 1, 1,-1}, { 1,-1,-1}, { 1, 1, 1}, { 1,-1, 1},
            { 1, 1, 1}, { 1, 1,-1}, {-1, 1,-1}, { 1, 1, 1}, {-1, 1,-1}, {-1, 1, 1},
            { 1,-1, 1}, {-1,-1,-1}, { 1,-1,-1}, { 1,-1, 1}, {-1,-1, 1}, {-1,-1,-1},
            {-1, 1, 1}, {-1,-1, 1}, { 1,-1, 1}, { 1, 1, 1}, {-1, 1, 1}, { 1,-1, 1},
            { 1, 1,-1}, {-1,-1,-1}, {-1, 1,-1}, { 1, 1,-1}, { 1,-1,-1}, {-1,-1,-1}
        };
        
        MTLResourceOptions bufferOptions = MTLResourceStorageModeShared;
        _skyboxBuffer = [_device newBufferWithBytes:verticess length:sizeof(verticess) options:bufferOptions];
        NSArray *imageNames = @[@"sh_rt", @"sh_lf", @"sh_up", @"sh_dn", @"sh_ft", @"sh_bk"];
        _texture = [[SBSkyboxTexture alloc] initWithDevice:_device images:imageNames];
        _camera = camera;
        _view = mtkView;
    }
    return self;
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size
{
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

- (void)drawInMTKView:(MTKView *)view
{
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"SkyboxCommandBuffer";
    
    MTLRenderPassDescriptor* descriptor = view.currentRenderPassDescriptor;
    descriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1);
    descriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    descriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    
    if (descriptor != nil)
    {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
        renderEncoder.label = @"SkyboxRenderEncoder";
        
        [renderEncoder setRenderPipelineState:_renderPipeline];
        [renderEncoder setDepthStencilState:_depthStencilState];
        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewportSize.x, _viewportSize.y, 0.0, 1.0}];
        [renderEncoder setVertexBuffer:_skyboxBuffer offset:0 atIndex:0];
        SBCameraParameters camera = (SBCameraParameters){_camera.viewMatrix, _camera.perspectiveMatrix};
        [renderEncoder setVertexBytes:&camera length:sizeof(camera) atIndex:1];
        [renderEncoder setFragmentTexture:_texture.texture atIndex:0];
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:36];
        [renderEncoder endEncoding];
        
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    [commandBuffer commit];
}

@end
