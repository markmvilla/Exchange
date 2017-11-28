//
//  MoreViewController.m
//  TCU Exchange
//
//  Created by Mark Villa on 1/3/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "MoreViewController.h"

#define SUBJECT_TAG 1

@interface MoreViewController ()
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UILabel *rewardsLabel;
@end

@implementation MoreViewController

- (id)initWithArray:(NSMutableArray *) passedmysqlArray {
    NSLog(@"More init");
    if (!(self = [super init])) {
        return (nil);
    }
    self.title = @"Menu";
    self.menuArray = [NSMutableArray arrayWithObjects:@"Tell Us What You Love!", @"Private Policy", @"Rules and Info", @"Rate TCU Exchange", @"Share TCU Exchange", nil];
    return (self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadRewardData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = appleNavBarGray;
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,height*1/3,width,height) style:UITableViewStyleGrouped];
    //self.tableView.backgroundColor = backgroundGray;
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    self.rewardsLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * .1, self.view.bounds.size.height*2/10, width * .8, 50)];
    self.rewardsLabel.backgroundColor = [UIColor clearColor];
    self.rewardsLabel.font = lRegularFont;
    self.rewardsLabel.textColor = overBackgroundGray;
    self.rewardsLabel.textAlignment = NSTextAlignmentCenter;
    self.rewardsLabel.numberOfLines = 0;
    [self.view addSubview:self.rewardsLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRewardData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://www.tcuexchange.com/rewards.php"
       parameters:@{}
          success:^(NSURLSessionDataTask *task, id responseObject) {
              self.rewardsLabel.text = responseObject[0];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}


#pragma mark - Table view data source and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 3;
    }
    else if(section == 1){
        return 1;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    static NSString *TableViewCellIdentifier = @"Cell";

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 12.0, 400, 25.0)];
    subjectLabel.textColor = overBackgroundGray;
    subjectLabel.font = mRegularFont;
    [cell.contentView addSubview:subjectLabel];
    if (indexPath.section == 0){
        subjectLabel.text = self.menuArray[indexPath.row];

    }
    else if (indexPath.section == 1){
        subjectLabel.text = self.menuArray[3 + indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, tableView.frame.size.width-5, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = overBackgroundGray;
    [label setFont:mRegularFont];
    NSString *string =@"test";
    [label setText:string];
    if(section == 0)
    {
        [label setText:@"Basics"];
    }
    else if(section == 1)
    {
        [label setText:@"Other"];
    }
    [view addSubview:label];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            ContactUsViewController *contactUsViewController = [[ContactUsViewController alloc] init];
            [self.navigationController pushViewController:contactUsViewController animated:YES];
        }
        else if (indexPath.row == 1) {
            PrivatePolicyViewController *privatePolicyViewController = [[PrivatePolicyViewController alloc] init];
            [self.navigationController pushViewController:privatePolicyViewController animated:YES];
        }
        else if (indexPath.row == 2) {
            InfoViewController *infoViewController = [[InfoViewController alloc] init];
            [self.navigationController pushViewController:infoViewController animated:YES];
        }
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            RateViewController *rateViewController = [[RateViewController alloc] init];
            [self.navigationController pushViewController:rateViewController animated:YES];
        }
    }
}

@end
