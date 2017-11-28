//
//  MessageViewController.h
//  TCUExchange
//
//  Created by Mark Villa on 3/11/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationStyles.h"
#import "MessageViewLayout.h"
#import "Coordinates.h"
#import "KeyboardBar.h"
#import "UIKit+AFNetworking/UIKit+AFNetworking.h"
#import "CameraViewController.h"
#import "UIScrollView+SVPullToRefresh.h"

static NSString * const reuseIdentifier2 = @"Cell";

@interface MessageViewController : UICollectionViewController <UIMessageViewLayoutDelegate, KeyboardBarDelegate>
- (id)initWithArray:(NSMutableArray *) passedmysqlArray initWithCollectionViewLayout:(UICollectionViewLayout *)layout;
@property (nonatomic, retain) NSMutableArray *mysqlArray;
@property (nonatomic, strong) NSMutableArray *responseArray;
@end
