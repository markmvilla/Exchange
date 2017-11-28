//
//  RateViewController.m
//  TCUExchange
//
//  Created by Mark Villa on 4/24/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "RateViewController.h"

@interface RateViewController ()
@property (nonatomic, retain) UIWebView *webView;

@end

@implementation RateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Rate Us!";

    self.view.backgroundColor = backgroundGray;

    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    NSString *urlAddress = @"http://www.tcuexchange.com/ratingredirect.php";
    NSURL *url = [[NSURL alloc] initWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
