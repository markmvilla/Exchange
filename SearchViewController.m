//
//  SearchViewController.m
//  TCU Exchange
//
//  Created by Mark Villa on 1/3/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "SearchViewController.h"

#define SUBJECT_TAG 1

@interface SearchViewController ()
@end

@implementation SearchViewController

- (id)initWithArray:(NSMutableArray *) passedmysqlArray {
    if (!(self = [super init])) {
        return (nil);
    }
    NSLog(@"Search init");
    self.mysqlArray = [[NSMutableArray alloc] initWithArray:passedmysqlArray];
    if ([self.mysqlArray[0] isEqualToString:@"courses"]){
        self.title = @"Search a Course";
    }
    else if([self.mysqlArray[0] isEqualToString:@"classes"]){
        self.title = @"Search a Class";
    }
    //[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:220.f/255 green:172.f/255 blue:255.f/255 alpha:1.f]];
    return (self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadTableViewData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGestureRecognizer];
    self.view.backgroundColor = appleNavBarGray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.responseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"cellForRowAtIndexPath");
    UITableViewCell *cell = nil;
    static NSString *TableViewCellIdentifier = @"Cell";

    //add reuseable cells in the future
    //cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
    cell.tag = [self.responseArray[indexPath.row][0] integerValue];
    if([self.mysqlArray[0] isEqualToString:@"courses"]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    //setSelectionStyle:UITableViewCellSelectionStyleNone
    UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 12.0, 400, 25.0)];
    subjectLabel.font = sRegularFont;
    [cell.contentView addSubview:subjectLabel];
    subjectLabel.text = self.responseArray[indexPath.row][1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"didSelectRowAtIndexPath");
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row != NSNotFound){
        NSNumber *tempIdHolder = self.mysqlArray[2];
        if ([self.mysqlArray[0] isEqual:@"courses"]){
            [self.mysqlArray replaceObjectAtIndex:0 withObject:@"classes"];
            [self.mysqlArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:cell.tag]];
            SearchViewController *classViewController = [[SearchViewController alloc] initWithArray:self.mysqlArray];
            [self.mysqlArray replaceObjectAtIndex:2 withObject:tempIdHolder];
            [self.mysqlArray replaceObjectAtIndex:0 withObject:@"courses"];
            classViewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:classViewController animated:YES];
        }
        else if([self.mysqlArray[0] isEqual:@"classes"]){
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

#pragma mark - loadTableViewData method
- (void)loadTableViewData{
    //NSLog(@"loadTableViewData");
    //NSLog(@"%@", self.mysqlArray);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://www.tcuexchange.com/service.php"
       parameters:@{@"process":self.mysqlArray[0],
                    @"submitData":self.mysqlArray[1],
                    @"selectedId":self.mysqlArray[2],
                    @"userId":self.mysqlArray[3]}
          success:^(NSURLSessionDataTask *task, id responseObject) {
              self.responseArray = (NSMutableArray *)responseObject;
              [self.tableView reloadData];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

#pragma mark - private method
- (void)addGestureRecognizer{
    if ([self.mysqlArray[0] isEqual:@"classes"]){
        UILongPressGestureRecognizer *viewGestureRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(viewGestureRecHandler:)];
        viewGestureRec.minimumPressDuration = 1.0;
        viewGestureRec.delegate = self;
        [self.view addGestureRecognizer:viewGestureRec];
    }
}

- (void)viewGestureRecHandler:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"http://www.tcuexchange.com/service.php"
           parameters:@{@"process":@"submitFavorites",
                        @"submitData":[NSNumber numberWithInteger:cell.tag],
                        @"selectedId":self.mysqlArray[2],
                        @"userId":self.mysqlArray[3]}
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Class Added"
                                                                                 message:@"This class has been added to your favorites list."
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
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self.mysqlArray[0] isEqual:@"classes"]){
    }
}

@end
