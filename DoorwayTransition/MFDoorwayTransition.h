//
//  MFDoorwayTransition.h
//  DoorwayTransition
//
//  Copyright (c) 2011 Ken Matsui. All rights reserved.
//

CGFloat degreeToRadian(CGFloat degree);

@interface MFDoorwayTransition : NSObject

@property (nonatomic, assign) UIView *view;
@property (nonatomic, assign) UIView *originalView;
@property (nonatomic, assign) UIView *nextView;

+ (CGImageRef)clipImageFromLayer:(CALayer *)layer size:(CGSize)size offsetX:(CGFloat)offsetX;

- (id)initWithBaseView:(UIView *)baseView firstView:(UIView *)firstView lastView:(UIView *)lastView;
- (void)buildAnimation;

@end
