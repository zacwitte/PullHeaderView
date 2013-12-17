//
//  ContentViewController.h
//  PullCycle
//
//  Created by Zachary Witte on 12/10/13.
//  Copyright (c) 2013 Zachary Witte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullHeaderView.h"

@interface ContentViewController : UIViewController <PullHeaderDelegate>

@property(nonatomic) PullHeaderView *nextPullHeaderView;
@property(nonatomic) PullHeaderView *prevPullHeaderView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property BOOL isLoading;

- (NSString*)pullHeaderSubtext:(PullHeaderView*)view;

- (IBAction)goNext:(id)sender;
- (IBAction)goPrevious:(id)sender;
- (void)preformTransitionToViewController:(UIViewController*)view direction:(NSString*)direction;

@end
