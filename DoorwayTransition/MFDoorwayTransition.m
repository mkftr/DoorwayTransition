//
//  MFDoorwayTransition.m
//  DoorwayTransition
//
//  Copyright (c) 2011 Ken Matsui. All rights reserved.
//

#import "MFDoorwayTransition.h"
#import <QuartzCore/QuartzCore.h>

CGFloat degreeToRadian(CGFloat degree)
{
    return degree * M_PI / 180.0f;
}

@interface MFDoorwayTransition ()
@property (nonatomic, retain) CALayer *doorLayerLeft;
@property (nonatomic, retain) CALayer *doorLayerRight;
@property (nonatomic, retain) CALayer *nextViewLayer;
- (CAAnimation *)openDoorAnimationWithRotationDegree:(CGFloat)degree;
- (CAAnimation *)zoomInAnimation;
@end


@implementation MFDoorwayTransition

@synthesize doorLayerLeft, doorLayerRight, nextViewLayer;
@synthesize view, originalView, nextView;

- (id)initWithBaseView:(UIView *)baseView firstView:(UIView *)firstView lastView:(UIView *)lastView
{
    if((self = [super init])) {
        self.view = baseView;
        self.originalView = firstView;
        self.nextView = lastView;
    }
    return self;
}

- (void)dealloc
{
    self.doorLayerLeft = nil;
    self.doorLayerRight = nil;
    self.nextViewLayer = nil;
    self.view = nil;
    self.originalView = nil;
    self.nextView = nil;
    [super dealloc];
}

- (void)buildAnimation
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect leftDoorRect = CGRectMake(0.0f, 0.0f, screenSize.width / 2.0f, screenSize.height);
    CGRect rightDoorRect = CGRectMake(screenSize.width / 2.0f, 0.0f, screenSize.width / 2.0f, screenSize.height);
    
    self.doorLayerLeft = [CALayer layer];
    self.doorLayerLeft.anchorPoint = CGPointMake(0.0f, 0.5f);
    self.doorLayerLeft.frame  = leftDoorRect;
    CATransform3D leftTransform = self.doorLayerLeft.transform;
    leftTransform.m34 = 1.0f / -420.0f;
    self.doorLayerLeft.transform = leftTransform;
    self.doorLayerLeft.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    self.doorLayerRight = [CALayer layer];
    self.doorLayerRight.anchorPoint = CGPointMake(1.0f, 0.5f);
    self.doorLayerRight.frame = rightDoorRect;
    CATransform3D rightTransform = self.doorLayerRight.transform;
    rightTransform.m34 = 1.0f / -420.0f;
    self.doorLayerRight.transform = rightTransform;
    self.doorLayerRight.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    self.nextViewLayer = [CALayer layer];
    self.nextViewLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    self.nextViewLayer.frame = CGRectMake(0.0f, 0.0f, screenSize.width, screenSize.height);
    CATransform3D nextViewTransform = self.nextViewLayer.transform;
    nextViewTransform.m34 = 1.0f / -420.0f;
    self.nextViewLayer.transform = nextViewTransform;
    
    // Left door image
    self.doorLayerLeft.contents = (id)[MFDoorwayTransition clipImageFromLayer:self.originalView.layer size:leftDoorRect.size offsetX:0.0f];
    
    // Right door image
    self.doorLayerRight.contents = (id)[MFDoorwayTransition clipImageFromLayer:self.view.layer size:rightDoorRect.size offsetX:-leftDoorRect.size.width];
    
    // Next view image
    self.nextViewLayer.contents = (id)[MFDoorwayTransition clipImageFromLayer:self.nextView.layer size:screenSize offsetX:0.0f];
    
    [self.view.layer addSublayer:self.nextViewLayer];
    [self.view.layer addSublayer:self.doorLayerLeft];
    [self.view.layer addSublayer:self.doorLayerRight];
    
    CAAnimation *leftDoorAnimation = [self openDoorAnimationWithRotationDegree:90.0f];
    leftDoorAnimation.delegate = self;
    [self.doorLayerLeft addAnimation:leftDoorAnimation forKey:@"doorAnimationStarted"];
    
    CAAnimation *rightDoorAnimation = [self openDoorAnimationWithRotationDegree:-90.0f];
    rightDoorAnimation.delegate = self;
    [self.doorLayerRight addAnimation:rightDoorAnimation forKey:@"doorAnimationStarted"];
    
    CAAnimation *nextViewAnimation = [self zoomInAnimation];
    nextViewAnimation.delegate = self;
    [self.nextViewLayer addAnimation:nextViewAnimation forKey:@"NextViewAnimationStarted"];
    
    [self.originalView removeFromSuperview];
}

//------------------------------------------------------------------------------
#pragma - Animation delegate
#
//- (void)animationDidStart:(CAAnimation *)anim
//{
//    [self.originalView removeFromSuperview];
//}
//
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag) {
        if([self.doorLayerLeft animationForKey:@"doorAnimationStarted"] == anim ||
           [self.doorLayerRight animationForKey:@"doorAnimationStarted"] == anim)
        {
            [self.doorLayerLeft removeFromSuperlayer];
            [self.doorLayerRight removeFromSuperlayer];
        }
        else 
        {
            [self.view addSubview:self.nextView];
        }
    }
}

//------------------------------------------------------------------------------
#pragma - Image utility
#
+ (CGImageRef)clipImageFromLayer:(CALayer *)layer size:(CGSize)size offsetX:(CGFloat)offsetX
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, offsetX, 0.0f);
    [layer renderInContext:context];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot.CGImage;
}

//------------------------------------------------------------------------------
#pragma - Animation set
#
- (CAAnimation *)zoomInAnimation
{
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *zoomInAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    zoomInAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    zoomInAnim.fromValue = [NSNumber numberWithFloat:-1000.0f];
    zoomInAnim.toValue = [NSNumber numberWithFloat:0.0f];
    
    CABasicAnimation *fadeInAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fadeInAnim.fromValue = [NSNumber numberWithFloat:0.0f];
    fadeInAnim.toValue = [NSNumber numberWithFloat:1.0f];
    
    animGroup.animations = [NSArray arrayWithObjects:zoomInAnim, fadeInAnim, nil];
    animGroup.duration = 1.5f;
    
    return animGroup;
}

- (CAAnimation *)openDoorAnimationWithRotationDegree:(CGFloat)degree
{
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *openAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    openAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    openAnim.fromValue = [NSNumber numberWithFloat:degreeToRadian(0.0f)];
    openAnim.toValue = [NSNumber numberWithFloat:degreeToRadian(degree)];
    
    CABasicAnimation *zoomInAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    zoomInAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    zoomInAnim.fromValue = [NSNumber numberWithFloat:0.0f];
    zoomInAnim.toValue = [NSNumber numberWithFloat:300.0f];
    
    animGroup.animations = [NSArray arrayWithObjects:openAnim, zoomInAnim, nil];
    animGroup.duration = 1.5f;
    
    return animGroup;
}
@end
