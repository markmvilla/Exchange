//
//  MyStuffEditViewController.h
//  TCUExchange
//
//  Created by Mark Villa on 6/5/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationStyles.h"
#import "AFNetworking.h"

@interface MyStuffEditViewController : UIViewController<UITextViewDelegate>
- (id)initWithArray:(NSMutableArray *) passedmysqlArray;
@property (nonatomic, retain) NSMutableArray *mysqlArray;
@property (nonatomic, strong) NSMutableArray *responseArray;
@property (strong, nonatomic) UILabel *editLabel;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *saveButton;

@end
