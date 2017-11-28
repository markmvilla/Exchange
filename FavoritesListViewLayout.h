//
//  FavoritesListViewLayout.h
//  TCUExchange
//
//  Created by Mark Villa on 3/11/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UICollectionViewLayout.h>
#import <UIKit/UICollectionView.h>

@protocol UIFavoritesListViewLayoutDelegate <NSObject>
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath;
@end

@interface FavoritesListViewLayout : UICollectionViewLayout
- (id)initWithView:(UIView *)view;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic) CGFloat itemWidth;
@property (nonatomic) CGFloat verticleOuterInset;
@property (nonatomic) CGFloat verticleInnerInset;
@property (nonatomic) CGFloat horizontalOuterInset;
@property (nonatomic) CGFloat horizontalInnerInset;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) NSMutableArray* layoutAttributes;  // array of UICollectionViewLayoutAttributes
@property (nonatomic, strong) NSMutableArray* pendingLayoutAttributes;
@end
