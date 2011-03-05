//
//  CFakeSplitView.h
//  FakeSplitView
//
//  Created by Jonathan Wight on 05/24/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFakeSplitViewControllerDelegate;

@interface CFakeSplitViewController : UIViewController {
}

@property (readwrite, nonatomic, copy) NSArray *viewControllers;
@property (readwrite, nonatomic, retain) IBOutlet UIViewController *masterViewController;
@property (readwrite, nonatomic, retain) IBOutlet UIViewController *detailViewController;
@property (readwrite, nonatomic, assign) CGFloat masterColumnWidth;
@property (readwrite, nonatomic, assign) CGFloat gutterWidth;
@property (readwrite, nonatomic, assign) BOOL hidesMasterViewInPortrait;
@property (readwrite, nonatomic, assign) BOOL deferDelegateMethods;
@property (readwrite, nonatomic, assign) id <CFakeSplitViewControllerDelegate> delegate;

@end

@protocol CFakeSplitViewControllerDelegate <NSObject>

@optional

// Called when a button should be added to a toolbar for a hidden view controller
- (void)splitViewController:(CFakeSplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc;

// Called when the view is shown again in the split view, invalidating the button and popover controller
- (void)splitViewController:(CFakeSplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem;

// Called when the view controller is shown in a popover so the delegate can take action like hiding other popovers.
- (void)splitViewController:(CFakeSplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController;

@end


@interface UIViewController (CFakeSplitViewController)

// If the view controller has a split view controller as its ancestor, return it. Returns nil otherwise.
@property(nonatomic, readonly, retain) CFakeSplitViewController *fakeSplitViewController;

@end