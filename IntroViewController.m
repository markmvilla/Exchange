//
//  IntroViewController.m
//  TCU Exchange
//
//  Created by Mark Villa on 2/25/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bkgImage = [UIImage imageNamed:@"tcu_2d_logo.png"];
    UIImageView *bkgImageView = [[UIImageView alloc] initWithImage:bkgImage];
    bkgImageView.backgroundColor = [UIColor whiteColor];
    bkgImageView.contentMode = UIViewContentModeScaleAspectFit;
    bkgImageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:bkgImageView];

    UIView *bkgOverlay = [[UIView alloc] init];
    bkgOverlay.contentMode = UIViewContentModeScaleAspectFit;
    bkgOverlay.frame = bkgImageView.frame;
    [bkgOverlay setBackgroundColor:[UIColor colorWithRed:0/250.f green:0/250.f blue:0/250.f alpha:.7]];
    [bkgImageView addSubview:bkgOverlay];

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];

    IntroChildViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];

    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IntroChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    IntroChildViewController *childViewController = [[IntroChildViewController alloc] init];
    childViewController.index = index;
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [(IntroChildViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(IntroChildViewController *)viewController index];
    index++;
    if (index == 2) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
