//
//  LayoutViewController.h
//  TCUExchange
//
//  Created by Mark Villa on 8/17/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationStyles.h"
#import "AFNetworking.h"
#import "FavoritesViewController.h"
#import "SearchViewController.h"
#import "MyStuffViewController.h"
#import "MoreViewController.h"
#import "DataClass.h"

@interface LayoutViewController : UIViewController<UITextViewDelegate, UIScrollViewDelegate>
- (id)initWithArray:(NSMutableArray *) passedmysqlArray;

@end
