//
//  SearchViewController.h
//  TCU Exchange
//
//  Created by Mark Villa on 1/3/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationStyles.h"
#import "AFNetworking.h"
//#import "JSON/SBJSON.h"
//#import "TabBarController.h"
//#import "QuestionViewController.h"

@interface SearchViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
- (id)initWithArray:(NSMutableArray *) passedmysqlArray;
@property (nonatomic, retain) NSMutableArray *mysqlArray;
@property (nonatomic, strong) NSMutableArray *responseArray;
@end
