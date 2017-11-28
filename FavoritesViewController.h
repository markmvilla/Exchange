//
//  FavoritesViewController.h
//  TCU Exchange
//
//  Created by Mark Villa on 2/15/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationStyles.h"
#import "AFNetworking.h"
//#import "JSON/SBJSON.h"
#import "QuestionViewController.h"
#import "FavoritesPostViewLayout.h"
#import "FavoritesListViewLayout.h"

@interface FavoritesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UIFavoritesPostViewLayoutDelegate, UIFavoritesListViewLayoutDelegate>
- (id)initWithArray:(NSMutableArray *) passedmysqlArray;
- (void)favlistexchangeData;
@property (nonatomic, retain) NSMutableArray *mysqlArray;
@end
