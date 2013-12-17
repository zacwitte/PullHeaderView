//
//	ContentViewController.m
//	PullCycle
//
//	Created by Zachary Witte on 12/10/13.
//	Copyright (c) 2013 Zachary Witte. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
}

- (void)viewDidAppear:(BOOL)animated {
	self.scrollView.contentSize = CGSizeMake(320, 900);
//	  NSLog(@"viewDidAppear bounds height: %f content height: %f", self.scrollView.bounds.size.height, self.scrollView.contentSize.height);
	
	if (_nextPullHeaderView == nil) {
		PullHeaderView *view = [[PullHeaderView alloc] initWithScrollView:self.scrollView arrowImageName:@"blackArrow.png" textColor:[UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0] subText:@"next article" position:PullHeaderBottom];
		view.delegate = self;
		[self.scrollView addSubview:view];
		_nextPullHeaderView = view;
	}
	
	if (_prevPullHeaderView == nil) {
		PullHeaderView *view = [[PullHeaderView alloc] initWithScrollView:self.scrollView arrowImageName:@"blackArrow.png" textColor:[UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0] subText:@"prev article" position:PullHeaderTop];
		view.delegate = self;
		[self.scrollView addSubview:view];
		_prevPullHeaderView = view;
	}
	
	[_nextPullHeaderView updateSubtext];
	[_prevPullHeaderView updateSubtext];
}

- (void)reloadTableViewDataSource{
	
	//	should be calling your tableviews data source model to reload
	//	put here just for demo
	self.isLoading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//	model should call this when its done loading
	self.isLoading = NO;
	[_nextPullHeaderView pullHeaderScrollViewDataSourceDidFinishedLoading:self.scrollView];
	[_prevPullHeaderView pullHeaderScrollViewDataSourceDidFinishedLoading:self.scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)pullHeaderDidTrigger:(PullHeaderView*)view {
	if (view == _prevPullHeaderView) {
		NSLog(@"Go previous action");
		[self goPrevious:nil];
	} else {
		NSLog(@"Go next action");
		[self goNext:nil];
	}

	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)pullHeaderSourceIsLoading:(PullHeaderView*)view {
	return self.isLoading; // should return if data source model is reloading
}

- (NSString*)pullHeaderSubtext:(PullHeaderView*)view {
	NSString *subText;
	if (view == _prevPullHeaderView) {
		subText = @"[Previous article title]";
	} else {
		subText = @"[Next article title]";
	}
//	  NSLog(@"returns subText: %@", subText);
	return subText;
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_nextPullHeaderView pullHeaderScrollViewDidScroll:scrollView];
	[_prevPullHeaderView pullHeaderScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_nextPullHeaderView pullHeaderScrollViewDidEndDragging:scrollView];
	[_prevPullHeaderView pullHeaderScrollViewDidEndDragging:scrollView];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


- (IBAction)goNext:(id)sender {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
	ContentViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
	//TODO: set post
	[self preformTransitionToViewController:dest direction:kCATransitionFromTop];
}

- (IBAction)goPrevious:(id)sender {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
	ContentViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
	//TODO: set post
	[self preformTransitionToViewController:dest direction:kCATransitionFromBottom];
}

- (void)preformTransitionToViewController:(UIViewController*)dest direction:(NSString*)direction {
	//NSLog(@"segue identifier: %@, source: %@, destination: %@", self.identifier, sourceViewController, destinationController);
	
	CATransition* transition = [CATransition animation];
	transition.duration = 0.5;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
	transition.subtype = direction; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
	
	[self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
	
	NSMutableArray *stack = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
	[stack removeLastObject];
	[stack addObject:dest];
	//	  [sourceViewController.navigationController pushViewController:destinationController animated:NO];
	[self.navigationController setViewControllers:stack animated:NO];
}

@end
