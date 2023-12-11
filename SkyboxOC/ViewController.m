//
//  ViewController.m
//  SkyboxOC
//
//  Created by Wynn Zhang on 12/10/23.
//

#import "ViewController.h"
#import "SBCamera.h"

@implementation ViewController
{
    MTKView *_view;
    SBCamera *_camera;
    SBRenderer *_renderer;
    NSPanGestureRecognizer *_panGestureRecognizer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _view = (MTKView*)self.view;
    _view.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
    _view.device = MTLCreateSystemDefaultDevice();
    
    NSAssert(_view.device, @"Metal is not supported on this device");
    
    _camera = [[SBCamera alloc] initWithPosition:simd_make_float3(0, 0, 0) rotation:simd_make_float3(0, 0, 0)];
    _renderer = [[SBRenderer alloc]initWithMetalKitView:_view camera:_camera];
    NSAssert(_renderer, @"Renderer failed initialization");
    [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];
    
    _view.delegate = _renderer;
    _panGestureRecognizer = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [_view addGestureRecognizer:_panGestureRecognizer];
}

- (void)handlePanGesture:(NSPanGestureRecognizer *)sender {
    NSPoint offset = [sender translationInView:_view];
    [_camera updateWithOffset:(CGSize){offset.x, offset.y}];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
