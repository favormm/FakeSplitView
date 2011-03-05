//
//  CFakeSplitView.m
//  FakeSplitView
//
//  Created by Jonathan Wight on 05/24/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CFakeSplitViewController.h"

typedef enum {
	Corner_TopLeft,
	Corner_TopRight,
	Corner_BottomLeft,
	Corner_BottomRight,
} ECorner;

@interface CFakeSplitViewController ()

@property (readwrite, nonatomic, retain) UIBarButtonItem *splitViewBarButtonItem;
@property (readwrite, nonatomic, retain) UIPopoverController *splitViewPopoverController;
@property (readwrite, nonatomic, retain) NSArray *splitViewCornerImageViews;

- (void)setup;
- (void)layoutToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)layoutCornerViewsToToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end

@implementation CFakeSplitViewController

@synthesize viewControllers;
@synthesize masterColumnWidth;
@synthesize gutterWidth;
@synthesize hidesMasterViewInPortrait;
@synthesize deferDelegateMethods;
@synthesize delegate;
@synthesize splitViewBarButtonItem;
@synthesize splitViewPopoverController;
@synthesize splitViewCornerImageViews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
    {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) != NULL)
        {
        [self setup];
        }
    return(self);
    }

- (id)initWithCoder:(NSCoder *)aDecoder
    {
    if ((self = [super initWithCoder:aDecoder]) != NULL)
        {
        [self setup];
        }
    return(self);
    }

- (void)dealloc
    {
    [viewControllers release];
    viewControllers = NULL;

    delegate = NULL;

    [splitViewBarButtonItem release];
    splitViewBarButtonItem = NULL;

    [splitViewPopoverController release];
    splitViewPopoverController = NULL;

    [splitViewCornerImageViews release];
    splitViewCornerImageViews = NULL;
    //
    [super dealloc];
    }

- (void)setup
    {
    self.viewControllers = [NSArray arrayWithObjects:
        [[[UIViewController alloc] init] autorelease],
        [[[UIViewController alloc] init] autorelease],
        NULL];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.opaque = YES;

    self.masterColumnWidth = 320.0;
    self.gutterWidth = 1.0f;
    self.hidesMasterViewInPortrait = NO;
    self.deferDelegateMethods = NO;
    }

- (void)viewDidUnload
    {
    [super viewDidUnload];
    //
    [splitViewBarButtonItem release];
    splitViewBarButtonItem = NULL;

    [splitViewPopoverController release];
    splitViewPopoverController = NULL;

    [splitViewCornerImageViews release];
    splitViewCornerImageViews = NULL;
    }

- (void)didReceiveMemoryWarning
    {
    if (self.hidesMasterViewInPortrait == NO || UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
        [splitViewPopoverController release];
        splitViewPopoverController = NULL;

        [splitViewCornerImageViews release];
        splitViewCornerImageViews = NULL;
        }
        
    [super didReceiveMemoryWarning];
    }

- (void)viewWillAppear:(BOOL)animated
    {
    [super viewWillAppear:animated];

    [self layoutToInterfaceOrientation:self.interfaceOrientation];

    if (self.delegate && [self.delegate respondsToSelector:@selector(splitViewController:willHideViewController:withBarButtonItem:forPopoverController:)])
        {
        UIBarButtonItem *theBarButtonItem = self.splitViewBarButtonItem;
        if (self.hidesMasterViewInPortrait == NO)
            {
            theBarButtonItem = NULL;
            }

        [self.delegate splitViewController:self willHideViewController:self.masterViewController withBarButtonItem:theBarButtonItem forPopoverController:NULL];
        }
    }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
    {
    return(YES);
    }

#pragma mark -

- (void)setViewControllers:(NSArray *)inViewControllers
    {
    NSAssert(inViewControllers.count == 2, @"Expecting 2 view controllers in array.");
    
    if (viewControllers != inViewControllers)
        {
        [viewControllers release];
        viewControllers = [inViewControllers copy];
        }

    [self layoutToInterfaceOrientation:self.interfaceOrientation];        
    }

- (UIViewController *)masterViewController
    {
    if (self.viewControllers.count != 2)
        {
        return(NULL);
        }
    else
        {
        return([self.viewControllers objectAtIndex:0]);
        }
    }

- (void)setMasterViewController:(UIViewController *)inMasterViewController
    {
    self.viewControllers = [NSArray arrayWithObjects:
        inMasterViewController,
        self.detailViewController,
        NULL];
    }

- (UIViewController *)detailViewController
    {
    if (self.viewControllers.count != 2)
        {
        return(NULL);
        }
    else
        {
        return([self.viewControllers objectAtIndex:1]);
        }
    }

- (void)setDetailViewController:(UIViewController *)inDetailViewController
    {
    self.viewControllers = [NSArray arrayWithObjects:
        self.masterViewController,
        inDetailViewController,
        NULL];
    }

#pragma mark -

- (UIBarButtonItem *)splitViewBarButtonItem
    {
    if (splitViewBarButtonItem == NULL)
        {
        NSString *theTitle = self.masterViewController.title;;
        NSAssert(theTitle != NULL, @"No title for master view controller");
        splitViewBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:theTitle style:UIBarButtonItemStylePlain target:self action:@selector(actionPopover:)];
        }
    return(splitViewBarButtonItem);
    }

- (UIPopoverController *)splitViewPopoverController
    {
    if (splitViewPopoverController == NULL)
        {
        splitViewPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.masterViewController];
        }
    return(splitViewPopoverController);
    }

- (NSArray *)splitViewCornerImageViews
    {
    if (splitViewCornerImageViews == NULL)
        {
        splitViewCornerImageViews = [[NSArray alloc] initWithObjects:
            [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewControllerCorner_TopLeft.png"]] autorelease],
            [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewControllerCorner_TopRight.png"]] autorelease],
            [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewControllerCorner_BottomLeft.png"]] autorelease],
            [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewControllerCorner_BottomRight.png"]] autorelease],
            NULL];
        }
    return(splitViewCornerImageViews);
    }

#pragma mark -

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
    {
    if (self.deferDelegateMethods == NO)
        {
        if (self.hidesMasterViewInPortrait == YES)
            {
            if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
                {
                if (self.delegate && [self.delegate respondsToSelector:@selector(splitViewController:willHideViewController:withBarButtonItem:forPopoverController:)])
                    {
                    UIBarButtonItem *theBarButtonItem = self.splitViewBarButtonItem;
                    if (self.hidesMasterViewInPortrait == NO)
                        {
                        theBarButtonItem = NULL;
                        }
                    
                    [self.delegate splitViewController:self willHideViewController:self.masterViewController withBarButtonItem:theBarButtonItem forPopoverController:self.splitViewPopoverController];
                    }
                }
            else
                {
                [self.splitViewPopoverController dismissPopoverAnimated:YES];

                if (self.delegate && [self.delegate respondsToSelector:@selector(splitViewController:willShowViewController:invalidatingBarButtonItem:)])
                    {
                    UIBarButtonItem *theBarButtonItem = self.splitViewBarButtonItem;
                    if (self.hidesMasterViewInPortrait == NO)
                        {
                        theBarButtonItem = NULL;
                        }

                    [self.delegate splitViewController:self willShowViewController:self.masterViewController invalidatingBarButtonItem:theBarButtonItem];
                    }
                }
            }
        }
    }

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
    {
    if (self.deferDelegateMethods == YES)
        {
        if (self.hidesMasterViewInPortrait == YES)
            {
            if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
                {
                if (self.delegate && [self.delegate respondsToSelector:@selector(splitViewController:willHideViewController:withBarButtonItem:forPopoverController:)])
                    {
                    UIBarButtonItem *theBarButtonItem = self.splitViewBarButtonItem;
                    if (self.hidesMasterViewInPortrait == NO)
                        {
                        theBarButtonItem = NULL;
                        }

                    [self.delegate splitViewController:self willHideViewController:self.masterViewController withBarButtonItem:theBarButtonItem forPopoverController:self.splitViewPopoverController];
                    }
                }
            else
                {
                [self.splitViewPopoverController dismissPopoverAnimated:YES];

                if (self.delegate && [self.delegate respondsToSelector:@selector(splitViewController:willShowViewController:invalidatingBarButtonItem:)])
                    {
                    UIBarButtonItem *theBarButtonItem = self.splitViewBarButtonItem;
                    if (self.hidesMasterViewInPortrait == NO)
                        {
                        theBarButtonItem = NULL;
                        }

                    [self.delegate splitViewController:self willShowViewController:self.masterViewController invalidatingBarButtonItem:theBarButtonItem];
                    }
                }
            }
        }
    }

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
    {
    [self layoutToInterfaceOrientation:toInterfaceOrientation];
    }

- (void)layoutToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
    {
    if (self.masterViewController.view != self.view)
        {
        [self.view insertSubview:self.masterViewController.view atIndex:0];
        }
        
    if (self.detailViewController.view != self.view)
        {
        [self.view insertSubview:self.detailViewController.view atIndex:1];
        }

    if (self.hidesMasterViewInPortrait == YES && UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
        {
        CGRect theBounds = self.view.bounds;

        theBounds.origin.x -= self.masterColumnWidth;
        theBounds.size.width += self.masterColumnWidth;
        
        CGRect theDetailViewFrame;
        CGRect theMasterViewFrame;
        CGRectDivide(theBounds, &theMasterViewFrame, &theDetailViewFrame, self.masterColumnWidth, CGRectMinXEdge);
        
        self.masterViewController.view.frame = theMasterViewFrame;
        self.detailViewController.view.frame = theDetailViewFrame;
        }
    else
        {
        CGRect theBounds = self.view.bounds;
            
        CGRect theDetailViewFrame;
        CGRect theMasterViewFrame;
        CGRectDivide(theBounds, &theMasterViewFrame, &theDetailViewFrame, self.masterColumnWidth, CGRectMinXEdge);
        
        theDetailViewFrame.origin.x += self.gutterWidth;
        theDetailViewFrame.size.width -= self.gutterWidth;
        
        self.masterViewController.view.frame = theMasterViewFrame;
        self.detailViewController.view.frame = theDetailViewFrame;
        }
        
    [self layoutCornerViewsToToInterfaceOrientation:toInterfaceOrientation];
    }

- (void)layoutCornerViewsToToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
    {
    if (self.hidesMasterViewInPortrait == NO || UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
        CGRect theBounds = self.view.bounds;

        CGRect theDetailViewFrame;
        CGRect theMasterViewFrame;
        CGRectDivide(theBounds, &theMasterViewFrame, &theDetailViewFrame, self.masterColumnWidth, CGRectMinXEdge);

        theDetailViewFrame.origin.x += self.gutterWidth;
        theDetailViewFrame.size.width -= self.gutterWidth;

        // ****
        UIImageView *theTopRightView = [self.splitViewCornerImageViews objectAtIndex:Corner_TopRight];
        theTopRightView.frame = (CGRect){
            .origin = {
                .x = CGRectGetMaxX(theMasterViewFrame) - theTopRightView.frame.size.width,
                .y = CGRectGetMinY(theMasterViewFrame),
                },
            .size = theTopRightView.frame.size
            };
        [self.view addSubview:theTopRightView];

        // ****
        UIImageView *theBottomRightView = [self.splitViewCornerImageViews objectAtIndex:Corner_BottomRight];
        theBottomRightView.frame = (CGRect){
            .origin = {
                .x = CGRectGetMaxX(theMasterViewFrame) - theBottomRightView.frame.size.width,
                .y = CGRectGetMaxY(theMasterViewFrame) - theBottomRightView.frame.size.height,
                },
            .size = theBottomRightView.frame.size
            };
        [self.view addSubview:theBottomRightView];

        // ****
        UIImageView *theTopLeftView = [self.splitViewCornerImageViews objectAtIndex:Corner_TopLeft];
        theTopLeftView.frame = (CGRect){
            .origin = {
                .x = CGRectGetMinX(theDetailViewFrame),
                .y = CGRectGetMinY(theDetailViewFrame),
                },
            .size = theTopLeftView.frame.size
            };
        [self.view addSubview:theTopLeftView];

        // ****
        UIImageView *theBottomLeftView = [self.splitViewCornerImageViews objectAtIndex:Corner_BottomLeft];
        theBottomLeftView.frame = (CGRect){
            .origin = {
                .x = CGRectGetMinX(theDetailViewFrame),
                .y = CGRectGetMaxY(theDetailViewFrame) - theBottomLeftView.frame.size.height,
                },
            .size = theBottomLeftView.frame.size
            };
        [self.view addSubview:theBottomLeftView];
        }
    else
        {
        for (UIView *theView in self.splitViewCornerImageViews)
            {
            [theView removeFromSuperview];
            }
        }
    }

#pragma mark -

- (IBAction)actionPopover:(id)inSender
    {
    if (self.splitViewPopoverController.popoverVisible)
        {
        [self.splitViewPopoverController dismissPopoverAnimated:YES];
        }
    else
        {
        if (self.delegate && [self.delegate respondsToSelector:@selector(splitViewController:popoverController:willPresentViewController:)])
            {
            [self.delegate splitViewController:self popoverController:self.splitViewPopoverController willPresentViewController:self.masterViewController];
            }
        [self.splitViewPopoverController presentPopoverFromBarButtonItem:inSender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
    }

@end
