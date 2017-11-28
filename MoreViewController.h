//
//  MoreViewController.h
//  TCU Exchange
//
//  Created by Mark Villa on 1/3/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationStyles.h"
#import "AFNetworking.h"
//#import "JSON/SBJSON.h"
#import "QuestionViewController.h"
#import "ContactUsViewController.h"
#import "InfoViewController.h"
#import "PrivatePolicyViewController.h"
#import "ShareViewController.h"
#import "RateViewController.h"

@interface MoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
- (id)initWithArray:(NSMutableArray *) passedmysqlArray;
@property (nonatomic, retain) NSMutableArray *mysqlArray;
@property (nonatomic, strong) NSMutableArray *menuArray;
@end
