//
//  ViewController.m
//  DoorwayTransition
//
//  Copyright (c) 2011 Ken Matsui. All rights reserved.
//

#import "ViewController.h"
#import "MFDoorwayTransition.h"

@implementation ViewController

@synthesize currentView, nextView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc 
{
    self.currentView = nil;
    self.nextView = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)clickOpenDoor:(id)sender
{
    MFDoorwayTransition *transition = [[MFDoorwayTransition alloc] initWithBaseView:self.view 
                                                                          firstView:self.currentView 
                                                                           lastView:self.nextView];
    [transition buildAnimation];
    [transition release];
}

@end
