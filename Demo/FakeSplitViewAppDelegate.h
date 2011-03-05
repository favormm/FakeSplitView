//
//  FakeSplitViewAppDelegate.h
//  FakeSplitView
//
//  Created by Jonathan Wight on 05/24/10.
//  Copyright toxicsoftware.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CFakeSplitViewController.h"

@interface FakeSplitViewAppDelegate : NSObject <UIApplicationDelegate, CFakeSplitViewControllerDelegate> {
    UIWindow *window;
    CFakeSplitViewController *viewController;
	UIViewController *masterController;
	UIViewController *detailController;
	UINavigationController *detailNavigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CFakeSplitViewController *viewController;
@property (nonatomic, retain) UIViewController *masterController;
@property (nonatomic, retain) UIViewController *detailController;
@property (nonatomic, retain) UINavigationController *detailNavigationController;

@end
