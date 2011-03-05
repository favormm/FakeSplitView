//
//  FakeSplitViewAppDelegate.m
//  FakeSplitView
//
//  Created by Jonathan Wight on 05/24/10.
//  Copyright toxicsoftware.com 2010. All rights reserved.
//

#import "FakeSplitViewAppDelegate.h"
#import "CFakeSplitViewController.h"

@implementation FakeSplitViewAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize masterController;
@synthesize detailController;;
@synthesize detailNavigationController;

- (void)dealloc
    {
    [viewController release];
    [window release];
    //
    [super dealloc];
    }

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {    
    self.viewController.hidesMasterViewInPortrait = YES;

    self.detailController = [[[UIViewController alloc] init] autorelease];
    self.detailController.view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sts.jpg"]] autorelease];
    self.detailController.view.contentMode = UIViewContentModeScaleAspectFit;
    self.detailController.view.backgroundColor = [UIColor whiteColor];
    self.detailController.title = @"Detail";
    self.detailController.wantsFullScreenLayout = YES;

    self.detailNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.detailController] autorelease];

    self.viewController.detailViewController = self.detailNavigationController;
    self.viewController.delegate = self;

    [self.window addSubview:self.viewController.view];
    [self.window makeKeyAndVisible];
    //
    return(YES);
    }

#pragma mark -

- (void)splitViewController:(CFakeSplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc
    {
    NSLog(@"WILL HIDE: %@", barButtonItem.title);
    [self.detailController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    }

- (void)splitViewController:(CFakeSplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
    {
    NSLog(@"WILL SHOW");
    [self.detailController.navigationItem setLeftBarButtonItem:NULL animated:YES];
    }

- (void)splitViewController:(CFakeSplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController;
    {
    NSLog(@"WILL PRESENT");
    }

@end
