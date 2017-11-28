//
//  SignUpViewController.m
//  TCUExchange
//
//  Created by Mark Villa on 8/17/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "SignUPViewController.h"

@interface SignUpViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIViewController *verifyViewController;
@property (strong, nonatomic) UILabel *phoneErrorLabel;
@property (strong, nonatomic) UITextView *phoneTextView;
@property (strong, nonatomic) UITextField *emailTextView;
@property (strong, nonatomic) UIButton *verifyButton;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *emailAddress;
@property int passcode;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIViewController *signupViewController;
@property (strong, nonatomic) UILabel *passcodeErrorLabel;
@property (strong, nonatomic) UITextView *passcodeTextView;
@property (strong, nonatomic) UIButton *signupButton;
@end

@implementation SignUpViewController

#define EMAILTEXTVIEW_TAG 0
#define EMAILTEXTVIEW_LENGTH 10
#define PHONETEXTVIEW_TAG 1
#define PHONETEXTVIEW_LENGTH 10
#define PASSCODETEXTVIEW_TAG 2
#define PASSCODETEXTVIEW_LENGTH 4

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.scrollView.contentSize = CGSizeMake(width * 2, height);
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setScrollEnabled:false];
    self.scrollView.delaysContentTouches = false;
    self.scrollView.bounces = false;
    self.scrollView.alwaysBounceVertical = true;
    self.scrollView.alwaysBounceHorizontal = false;
    self.scrollView.directionalLockEnabled = false;
    self.scrollView.backgroundColor = backgroundGray;
    [self.view addSubview:self.scrollView];

    self.verifyViewController = [[UIViewController alloc] init];
    [self addChildViewController:self.verifyViewController];
    [self.scrollView addSubview:self.verifyViewController.view];
    [self.verifyViewController didMoveToParentViewController:self];
    self.verifyViewController.view.backgroundColor = [UIColor whiteColor];
    self.verifyViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    self.signupViewController = [[UIViewController alloc] init];
    [self addChildViewController:self.signupViewController];
    [self.scrollView addSubview:self.signupViewController.view];
    [self.signupViewController didMoveToParentViewController:self];
    self.signupViewController.view.backgroundColor = [UIColor whiteColor];
    self.signupViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);


    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * .1, self.scrollView.frame.size.height/6, width * .8, 25)];
    emailLabel.font = mRegularFont;
    emailLabel.numberOfLines = 0;
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = @"TCU Email";
    emailLabel.textColor = [UIColor purpleColor];
    [self.scrollView addSubview:emailLabel];

    self.emailTextView = [[UITextField alloc] initWithFrame:CGRectMake(width * .1, emailLabel.frame.origin.y + 25, width * .8, 50)];
    self.emailTextView.tag = EMAILTEXTVIEW_TAG;
    self.emailTextView.textColor = [UIColor purpleColor];
    self.emailTextView.font = passcodeVerificationFont;
    //self.emailTextView.textAlignment = NSTextAlignmentCenter;
    self.emailTextView.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextView.backgroundColor=[UIColor clearColor];
    [self.scrollView addSubview:self.emailTextView];
    [self.emailTextView setDelegate:self];

    UIView *emailUnderline = [[UIView alloc] initWithFrame:CGRectMake(width * .1, self.emailTextView.frame.origin.y + 50, width * .8, 1)];
    emailUnderline.backgroundColor = [UIColor purpleColor];
    [self.scrollView addSubview:emailUnderline];


    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * .1, emailUnderline.frame.origin.y+emailUnderline.bounds.size.height+10, width * .8, 25)];
    phoneLabel.font = mRegularFont;
    phoneLabel.numberOfLines = 0;
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.text = @"Phone Number";
    phoneLabel.textColor = [UIColor purpleColor];
    [self.scrollView addSubview:phoneLabel];

    self.phoneErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * .1, emailLabel.frame.origin.y - 50, width * .8, 25)];
    self.phoneErrorLabel.font = mRegularFont;
    self.phoneErrorLabel.textAlignment = NSTextAlignmentCenter;
    self.phoneErrorLabel.numberOfLines = 0;
    self.phoneErrorLabel.backgroundColor = [UIColor clearColor];
    self.phoneErrorLabel.text = @"";
    self.phoneErrorLabel.textColor = [UIColor purpleColor];
    [self.scrollView addSubview:self.phoneErrorLabel];

    self.phoneTextView = [[UITextView alloc] initWithFrame:CGRectMake(width * .1, phoneLabel.frame.origin.y + 25, width * .8, 50)];
    self.phoneTextView.tag = PHONETEXTVIEW_TAG;
    self.phoneTextView.textColor = [UIColor purpleColor];
    self.phoneTextView.font = passcodeVerificationFont;
    self.phoneTextView.textAlignment = NSTextAlignmentCenter;
    self.phoneTextView.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextView.backgroundColor=[UIColor clearColor];
    [self.scrollView addSubview:self.phoneTextView];
    [self.phoneTextView setDelegate:self];

    UIView *phoneUnderline = [[UIView alloc] initWithFrame:CGRectMake(width * .1, self.phoneTextView.frame.origin.y + 50, width * .8, 1)];
    phoneUnderline.backgroundColor = [UIColor purpleColor];
    [self.scrollView addSubview:phoneUnderline];

    self.verifyButton = [[UIButton alloc] initWithFrame:CGRectMake(width * .2, phoneUnderline.frame.origin.y + 51, width * .6, 50)];
    [self.verifyButton addTarget:self action:@selector(verifyTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.verifyButton addTarget:self action:@selector(verifyTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.verifyButton addTarget:self action:@selector(verifyTouchUpInside:event:) forControlEvents:UIControlEventTouchUpInside];
    self.verifyButton.backgroundColor = backgroundGray;
    self.verifyButton.layer.cornerRadius = 25.0;
    [self.verifyButton setTitle:@"Verify" forState:UIControlStateNormal];
    [self.verifyButton setTitleColor:[UIColor colorWithRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.f] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.verifyButton];

    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(width +10, 20, 100, 30)];
    [self.backButton addTarget:self action:@selector(backTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.backgroundColor = [UIColor purpleColor];
    self.backButton.layer.cornerRadius = 15.0;
    [self.backButton setTitle:@"Return" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor colorWithRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.f] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.backButton];

    UILabel *passcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 1.1, self.scrollView.frame.size.height/3, width * .8, 25)];
    passcodeLabel.font = mRegularFont;
    passcodeLabel.numberOfLines = 0;
    passcodeLabel.backgroundColor = [UIColor clearColor];
    passcodeLabel.text = @"Passcode";
    passcodeLabel.textColor = [UIColor purpleColor];
    [self.scrollView addSubview:passcodeLabel];

    self.passcodeErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 1.1, passcodeLabel.frame.origin.y - 100, width * .8, 25)];
    self.passcodeErrorLabel.font = mRegularFont;
    self.passcodeErrorLabel.textAlignment = NSTextAlignmentCenter;
    self.passcodeErrorLabel.numberOfLines = 0;
    self.passcodeErrorLabel.backgroundColor = [UIColor clearColor];
    self.passcodeErrorLabel.text = @"";
    self.passcodeErrorLabel.textColor = [UIColor purpleColor];
    [self.scrollView addSubview:self.passcodeErrorLabel];

    self.passcodeTextView = [[UITextView alloc] initWithFrame:CGRectMake(width * 1.1, passcodeLabel.frame.origin.y + 25, width * .8, 50)];
    self.passcodeTextView.tag = PASSCODETEXTVIEW_TAG;
    self.passcodeTextView.textColor = [UIColor purpleColor];
    self.passcodeTextView.font = passcodeVerificationFont;
    self.passcodeTextView.textAlignment = NSTextAlignmentCenter;
    self.passcodeTextView.keyboardType = UIKeyboardTypeNumberPad;
    self.passcodeTextView.backgroundColor=[UIColor clearColor];
    [self.scrollView addSubview:self.passcodeTextView];
    [self.passcodeTextView setDelegate:self];

    UIView *passcodeUnderline = [[UIView alloc] initWithFrame:CGRectMake(width * 1.1, self.passcodeTextView.frame.origin.y + 50, width * .8, 1)];
    passcodeUnderline.backgroundColor = [UIColor purpleColor];
    [self.scrollView addSubview:passcodeUnderline];

    self.signupButton = [[UIButton alloc] initWithFrame:CGRectMake(width * 1.2, passcodeUnderline.frame.origin.y + 51, width * .6, 50)];
    [self.signupButton addTarget:self action:@selector(signupTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.signupButton addTarget:self action:@selector(signupTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.signupButton addTarget:self action:@selector(signupTouchUpInside:event:) forControlEvents:UIControlEventTouchUpInside];
    self.signupButton.backgroundColor = backgroundGray;
    self.signupButton.layer.cornerRadius = 25.0;
    [self.signupButton setTitle:@"Signup" forState:UIControlStateNormal];
    [self.signupButton setTitleColor:[UIColor colorWithRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.f] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.signupButton];

    [self.emailTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    self.phoneErrorLabel.text = @"";
    self.passcodeErrorLabel.text = @"";
    if(textView.tag == EMAILTEXTVIEW_TAG){
        return true;
    }
    else if(textView.tag == PHONETEXTVIEW_TAG){
        return textView.text.length + (text.length - range.length) <= PHONETEXTVIEW_LENGTH;
    }
    else if(textView.tag == PASSCODETEXTVIEW_TAG){
        return textView.text.length + (text.length - range.length) <= PASSCODETEXTVIEW_LENGTH;
    }
    else{
        return false;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if(textView.tag == PHONETEXTVIEW_TAG){
        if(textView.text.length == PHONETEXTVIEW_LENGTH){
            self.verifyButton.backgroundColor = selectedGray;
        }
        else{
            self.verifyButton.backgroundColor = backgroundGray;
        }
    }
    else if(textView.tag == PASSCODETEXTVIEW_TAG){
        if(textView.text.length == PASSCODETEXTVIEW_LENGTH){
            self.signupButton.backgroundColor = selectedGray;
        }
        else{
            self.signupButton.backgroundColor = backgroundGray;
        }
    }
}

- (void)verifyTouchDown{
     self.verifyButton.backgroundColor = [UIColor purpleColor];
 }

- (void)verifyTouchUpOutside{
     self.verifyButton.backgroundColor = backgroundGray;
}

- (void)verifyTouchUpInside:(UIButton *)sender event:(UIEvent *)event{
    CGPoint location = [[[event allTouches] anyObject] locationInView:sender];
    if (!CGRectContainsPoint(sender.bounds, location)) {
        // Outside of bounds, so ignore:
        self.verifyButton.backgroundColor = backgroundGray;
        return;
    }
    if(self.phoneTextView.text.length == PHONETEXTVIEW_LENGTH){
        self.phoneNumber = self.phoneTextView.text;
        self.emailAddress = self.emailTextView.text;
        [self messageUser];
        [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0)];
        [self.passcodeTextView becomeFirstResponder];
        self.phoneTextView.text = @"";
        self.emailTextView.text = @"";
    }
    else{
        self.phoneErrorLabel.text = @"Invalid phone number.";
    }
    self.verifyButton.backgroundColor = backgroundGray;
}

- (void)messageUser{
    self.passcode = [self getRandomNumberBetween:1000 to:9999];
    NSString *urlParameters = [NSString stringWithFormat:@"http://api.clickatell.com/your_link",self.phoneNumber, self.passcode];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlParameters
       parameters:nil
          success:^(NSURLSessionDataTask *task, id responseObject) {
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (int)getRandomNumberBetween:(int)from to:(int)to{
    return (int)from + arc4random() % (to-from+1);
}

- (void)signupTouchDown{
    self.signupButton.backgroundColor = [UIColor purpleColor];
}

- (void)signupTouchUpOutside{
    self.signupButton.backgroundColor = backgroundGray;
}

- (void)signupTouchUpInside:(UIButton *)sender event:(UIEvent *)event{
    CGPoint location = [[[event allTouches] anyObject] locationInView:sender];
    if (!CGRectContainsPoint(sender.bounds, location)) {
        // Outside of bounds, so ignore:
        self.signupButton.backgroundColor = backgroundGray;
        return;
    }
    if(self.passcodeTextView.text.length == PASSCODETEXTVIEW_LENGTH){
        if([self.passcodeTextView.text intValue] == self.passcode){
            self.passcodeTextView.text = @"";
            self.signupButton.backgroundColor = backgroundGray;
            NSDictionary *submitDataDictionary = @{@"phonenumber":self.phoneNumber, @"emailaddress": self.emailAddress};
            NSDictionary *parameterDictionary = @{@"process": @"enterphonenumber", @"submitData": submitDataDictionary, @"selectedId": @"nil", @"userId": [[[UIDevice currentDevice] identifierForVendor] UUIDString]};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:@"http://www.tcuexchange.com/service.php"
               parameters:parameterDictionary
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                      IntroViewController *introViewController = [[IntroViewController alloc] init];
                      appDelegate.window.rootViewController = introViewController;
                      [appDelegate.window makeKeyAndVisible];
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSLog(@"Error: %@", error);
                  }];
        }
        else{
            self.passcodeErrorLabel.text = @"passcode not correct";
            self.signupButton.backgroundColor = selectedGray;
        }
    }
    else{
        self.passcodeErrorLabel.text = @"Invalid passcode.";
        self.signupButton.backgroundColor = backgroundGray;
    }
}

- (void)backTouchUpInside{
    self.phoneTextView.text = @"";
    self.emailTextView.text = @"";
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.emailTextView becomeFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, we often want to do a little preparation, but we won't use this for now
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
