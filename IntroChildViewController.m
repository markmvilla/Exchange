//
//  IntroChildViewController.m
//  TCU Exchange
//
//  Created by Mark Villa on 2/25/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "IntroChildViewController.h"

@interface IntroChildViewController ()
@property (strong, nonatomic) UIButton *getStartedButton;
@end

@implementation IntroChildViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    UILabel *screenshotDesc1 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height * 3/8, self.view.bounds.size.width, 55)];
    screenshotDesc1.translatesAutoresizingMaskIntoConstraints = false;

    if(self.index == 0){
        screenshotDesc1.text = @"\u2022 Exchange lets you connect with fellow classmates.\r\r \u2022 You can post questions and respond to individuals using classroom boards.\r\r \u2022 You can add/delete favorite classes by pressholding.\r\r \u2022 Swipe to get started.";
        screenshotDesc1.backgroundColor = [UIColor clearColor];
        screenshotDesc1.textAlignment = NSTextAlignmentLeft;
        screenshotDesc1.font = mBRegularFont;
        screenshotDesc1.textColor = [UIColor whiteColor];
        screenshotDesc1.numberOfLines = 0;
        [self.view addSubview:screenshotDesc1];

        NSDictionary *views = @{@"view" : self.view, @"screenshotDesc1": screenshotDesc1};
        NSArray *introViewConstraints;
        introViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[screenshotDesc1(300)]" options:0 metrics:nil views:views];
        [self.view addConstraints:introViewConstraints];
        introViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[screenshotDesc1]-5-|" options:0 metrics:nil views:views];
        [self.view addConstraints:introViewConstraints];

        NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
        [paragrahStyle setParagraphSpacing:4];
        [paragrahStyle setParagraphSpacingBefore:3];
        [paragrahStyle setFirstLineHeadIndent:0.0f];  // First line is the one with bullet point
        [paragrahStyle setHeadIndent:15.0f];    // Set the indent for given bullet character and size font
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:screenshotDesc1.text];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle
                                 range:NSMakeRange(0, [screenshotDesc1.text length])];
        screenshotDesc1.attributedText = attributedString;
    }
    if(self.index == 1){
        self.getStartedButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, self.view.bounds.size.height/2-25, 200, 50)];
        self.getStartedButton.layer.cornerRadius = 25.0;
        self.getStartedButton.layer.borderWidth = 3.0;
        [self.getStartedButton setTitle:@"Get Started" forState:UIControlStateNormal];
        self.getStartedButton.layer.borderColor = [[UIColor colorWithRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.f] CGColor];
        self.getStartedButton.backgroundColor = [UIColor clearColor];
        [self.getStartedButton setTitleColor:[UIColor colorWithRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.f] forState:UIControlStateNormal];
        [self.getStartedButton addTarget:self action:@selector(getStartedTouchDown) forControlEvents:UIControlEventTouchDown];
        [self.getStartedButton addTarget:self action:@selector(getStartedTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [self.getStartedButton addTarget:self action:@selector(getStartedTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.getStartedButton];
    }
}

- (void) getStartedTouchDown {
    self.getStartedButton.layer.borderColor = [[UIColor purpleColor] CGColor];
    self.getStartedButton.backgroundColor = [UIColor purpleColor];
    [self.getStartedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void) getStartedTouchUpOutside{
    self.getStartedButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.getStartedButton.backgroundColor = [UIColor clearColor];
    [self.getStartedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

- (void) getStartedTouchUpInside{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate normalLaunch];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
