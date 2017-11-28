//
//  IntroViewController.h
//  TCU Exchange
//
//  Created by Mark Villa on 2/25/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "IntroChildViewController.h"

@interface IntroViewController : UIViewController <UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageController;
@end
