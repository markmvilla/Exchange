//
//  ContactUsViewController.m
//  TCUExchange
//
//  Created by Mark Villa on 4/24/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()

@property (strong, nonatomic) UIButton *ContactUsButton;
@property (strong, nonatomic) UITextView *request;
@property (strong, nonatomic) UITextView *email;
@end

@implementation ContactUsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Contact Us";

    self.view.backgroundColor = backgroundGray;

    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    scrollView.contentSize = self.view.frame.size;
    scrollView.backgroundColor = backgroundGray;
    [self.view addSubview:scrollView];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * .05, 0, width* .9, 75)];
    headerLabel.font = mRegularFont;
    headerLabel.numberOfLines = 0;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = @"You may contact us for any reason, whether you would like to submit a request, have a report or question or just to give any advice.";
    headerLabel.textColor = overBackgroundGray;
    [scrollView addSubview:headerLabel];

    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * .05, headerLabel.frame.origin.y + 75, width* .9, 25)];
    emailLabel.font = mRegularFont;
    emailLabel.numberOfLines = 0;
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = @"Email";
    emailLabel.textColor = overBackgroundGray;
    [scrollView addSubview:emailLabel];

    self.email = [[UITextView alloc] initWithFrame:CGRectMake(width * .05, emailLabel.frame.origin.y + 25, width* .9, 50)];
    self.email.textColor = [UIColor darkGrayColor];
    self.email.font = mRegularFont;
    self.email.backgroundColor=[UIColor whiteColor];
    [scrollView addSubview:self.email];

    UILabel *requestLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * .05, self.email.frame.origin.y + 50, width* .9, 25)];
    requestLabel.font = mRegularFont;
    requestLabel.numberOfLines = 0;
    requestLabel.backgroundColor = [UIColor clearColor];
    requestLabel.text = @"Request";
    requestLabel.textColor = overBackgroundGray;
    [scrollView addSubview:requestLabel];

    self.request = [[UITextView alloc] initWithFrame:CGRectMake(width * .05, requestLabel.frame.origin.y+25, width* .9, 200)];
    self.request.delegate = self;
    self.request.textColor = [UIColor darkGrayColor];
    self.request.font = mRegularFont;
    self.request.backgroundColor=[UIColor whiteColor];
    [scrollView addSubview:self.request];

    self.ContactUsButton = [[UIButton alloc]initWithFrame:CGRectMake(width/2-150, self.request.frame.origin.y+205, 300, 50)];
    self.ContactUsButton.layer.cornerRadius = 2.0;
    self.ContactUsButton.layer.borderWidth = 3.0;
    self.ContactUsButton.font = lRegularFont;
    [self.ContactUsButton setTitle:@"Send" forState:UIControlStateNormal];
    self.ContactUsButton.layer.borderColor = [overBackgroundGray CGColor];
    self.ContactUsButton.backgroundColor = overBackgroundGray;
    [self.ContactUsButton setTitleColor:[UIColor colorWithRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.f] forState:UIControlStateNormal];
    [self.ContactUsButton addTarget:self action:@selector(getStartedTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.ContactUsButton addTarget:self action:@selector(getStartedTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.ContactUsButton addTarget:self action:@selector(getStartedTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:self.ContactUsButton];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTouchView)];
    recognizer.cancelsTouchesInView = NO;
    //[self.view addGestureRecognizer:recognizer];
}

- (void)didTouchView {
    NSLog(@"didTouchView");
    //[self becomeFirstResponder];
    [self.view endEditing:YES];
}

- (void) getStartedTouchDown {
    self.ContactUsButton.backgroundColor = [UIColor clearColor];
}

- (void) getStartedTouchUpOutside{
    self.ContactUsButton.backgroundColor = overBackgroundGray;
}

- (void) getStartedTouchUpInside{
    self.ContactUsButton.backgroundColor = overBackgroundGray;
    NSMutableArray *contactUsArray = [NSMutableArray arrayWithObjects: [[[UIDevice currentDevice] identifierForVendor] UUIDString], self.email.text, self.request.text, nil];
    NSString *contactUsString = [NSString stringWithFormat:@"%@ %@ %@", contactUsArray[0], contactUsArray[1], contactUsArray[2]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://www.tcuexchange.com/service.php"
       parameters:@{@"process":@"contactUs",
                    @"submitData":contactUsString,
                    @"selectedId":@"none",
                    @"userId":[NSString stringWithFormat:[[[UIDevice currentDevice] identifierForVendor] UUIDString]]}
          success:^(NSURLSessionDataTask *task, id responseObject) {
              UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thank You"
                                                                             message:@"Your message has been sent!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
              UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * action) {[self becomeFirstResponder];}];

              [alert addAction:defaultAction];
              [self presentViewController:alert animated:YES completion:nil];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing");
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    [self.view setFrame:CGRectMake(0,-110, width, height)];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textViewShouldEndEditing");
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    [self.view setFrame:CGRectMake(0,0,width,height)];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
