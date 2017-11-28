//
//  MyStuffViewController.h
//  TCUExchange
//
//  Created by Mark Villa on 3/5/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationStyles.h"
#import "TouchDownGestureRecognizer.h"
#import "MyStuffViewLayout.h"
#import "Coordinates.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "MessageViewController.h"
#import "MyStuffEditViewController.h"


@interface MyStuffViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIMyStuffViewLayoutDelegate>
- (id)initWithArray:(NSMutableArray *) passedmysqlArray;
@property (nonatomic, retain) NSMutableArray *mysqlArray;
@property (nonatomic, strong) NSMutableArray *responseArray;
@end
