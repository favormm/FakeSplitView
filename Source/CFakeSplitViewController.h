//
//  CFakeSplitView.h
//  FakeSplitView
//
//  Created by Jonathan Wight on 05/24/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFakeSplitViewControllerDelegate;

/// A UISplitViewController work-alike that allows configuration of widths and whether the master view is displayed in portrait mode.
@interface CFakeSplitViewController : UIViewController {
}

@property (readwrite, nonatomic, copy) NSArray *viewControllers;

/// Convenince property.
@property (readwrite, nonatomic, retain) IBOutlet UIViewController *masterViewController;

/// Convenince property.
@property (readwrite, nonatomic, retain) IBOutlet UIViewController *detailViewController;

/// Width of the master view. By default this is 320 pixels.
@property (readwrite, nonatomic, assign) CGFloat masterColumnWidth;

/// Width of the gutter between master and defail views. By default this is 1 pixel.
@property (readwrite, nonatomic, assign) CGFloat gutterWidth;

/// If true this class works just like UISplitViewController, using a UIPopover for the master view while in portrait mode. Default: YES.
@property (readwrite, nonatomic, assign) BOOL hidesMasterViewInPortrait;

/// To be honest I wrote this code a long time ago and forget exactly why this is a property. Go figure.
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