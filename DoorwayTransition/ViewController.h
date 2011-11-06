//
//  ViewController.h
//  DoorwayTransition
//
//  Copyright (c) 2011 Ken Matsui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIView *currentView;
@property (nonatomic, retain) IBOutlet UIView *nextView;

- (IBAction)clickOpenDoor:(id)sender;

@end
