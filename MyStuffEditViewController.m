//
//  MyStuffEditViewController.m
//  TCUExchange
//
//  Created by Mark Villa on 6/5/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "MyStuffEditViewController.h"

@interface MyStuffEditViewController ()
@property (strong, nonatomic) UITextView *request;

@end

@implementation MyStuffEditViewController

- (id)initWithArray:(NSMutableArray *) passedmysqlArray {
    if (!(self = [super init])) {
        return (nil);
    }
    self.mysqlArray = [[NSMutableArray alloc] initWithArray:passedmysqlArray];
    NSLog(@"%@",self.mysqlArray);
    self.title = @"My Stuff";
    return (self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    self.navigationController.navigationBarHidden = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Edit";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];

    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;



    self.editLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    self.editLabel.font = lRegularFont;
    self.editLabel.backgroundColor = appleNavBarGray;
    self.editLabel.textColor = [UIColor grayColor];
    self.editLabel.textAlignment = NSTextAlignmentCenter;
    self.editLabel.text = [NSString stringWithFormat:@"Edit your comment"];
    [self.view addSubview:self.editLabel];

    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    self.cancelButton.backgroundColor = [UIColor clearColor];
    self.cancelButton.font = lRegularFont;
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelEditButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];

    self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake(width-70, 0, 70, 40)];
    self.saveButton.backgroundColor = [UIColor clearColor];
    self.saveButton.font = lRegularFont;
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveEditButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.editLabel.bounds.size.height, width, height)];
    scrollView.contentSize = self.view.frame.size;
    scrollView.backgroundColor = backgroundGray;
    [self.view addSubview:scrollView];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * .05, 0, width* .9, 75)];
    headerLabel.font = mRegularFont;
    headerLabel.numberOfLines = 0;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = @"Edit your comment below.";
    headerLabel.textColor = overBackgroundGray;
    [scrollView addSubview:headerLabel];

    self.request = [[UITextView alloc] initWithFrame:CGRectMake(width * .05, headerLabel.frame.origin.y+75, width* .9, 200)];
    self.request.delegate = self;
    self.request.textColor = [UIColor darkGrayColor];
    self.request.font = mRegularFont;
    self.request.backgroundColor=[UIColor whiteColor];
    [scrollView addSubview:self.request];

    [self EditData];
}

#pragma mark - private methods
- (void)EditData {
    if ([self.mysqlArray[0] isEqualToString:@"myquestions"]) {
        NSLog(@"question");
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"http://www.tcuexchange.com/service.php"
           parameters:@{@"process":@"fetchsinglequestion",
                        @"submitData":self.mysqlArray[1],
                        @"selectedId":self.mysqlArray[2],
                        @"userId":self.mysqlArray[3]}
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  self.request.text = [NSString stringWithFormat:@"%@", responseObject[0][1]];
              }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    }
    else if ([self.mysqlArray[0] isEqualToString:@"mymessages"]) {
        NSLog(@"message");
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"http://www.tcuexchange.com/service.php"
           parameters:@{@"process":@"fetchsinglemessage",
                        @"submitData":self.mysqlArray[1],
                        @"selectedId":self.mysqlArray[2],
                        @"userId":self.mysqlArray[3]}
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  self.request.text = [NSString stringWithFormat:@"%@", responseObject[0][1]];
              }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    }

}

// Cancel
- (void)cancelEditButton:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

// Save
- (void)saveEditButton:(id)sender {
    if ([self.mysqlArray[0] isEqualToString:@"myquestions"]) {
        NSNumber *tempIdHolder1 = self.mysqlArray[1];
        [self.mysqlArray replaceObjectAtIndex:1 withObject:self.request.text];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"http://www.tcuexchange.com/service.php"
           parameters:@{@"process":@"editquestion",
                        @"submitData":self.mysqlArray[1],
                        @"selectedId":self.mysqlArray[2],
                        @"userId":self.mysqlArray[3]}
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  [self.navigationController popViewControllerAnimated:true];
              }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
        [self.mysqlArray replaceObjectAtIndex:1 withObject:tempIdHolder1];
    }
    else if ([self.mysqlArray[0] isEqualToString:@"mymessages"]) {
        NSNumber *tempIdHolder1 = self.mysqlArray[1];
        [self.mysqlArray replaceObjectAtIndex:1 withObject:self.request.text];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"http://www.tcuexchange.com/service.php"
           parameters:@{@"process":@"editmessage",
                        @"submitData":self.mysqlArray[1],
                        @"selectedId":self.mysqlArray[2],
                        @"userId":self.mysqlArray[3]}
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  [self.navigationController popViewControllerAnimated:true];
              }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
        [self.mysqlArray replaceObjectAtIndex:1 withObject:tempIdHolder1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
