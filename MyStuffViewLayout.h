//
//  MyStuffViewLayout.h
//  TCUExchange
//
//  Created by Mark Villa on 3/11/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UICollectionViewLayout.h>
#import <UIKit/UICollectionView.h>

@protocol UIMyStuffViewLayoutDelegate <NSObject>
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath;
@end

@interface MyStuffViewLayout : UICollectionViewLayout
- (id)initWithView:(UIView *)view;
@property (nonatomic) CGFloat leftRightInset;
@property (nonatomic) CGFloat topInset;
@property (nonatomic) CGFloat bottomInset;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) CGFloat interitemSpacing;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic) CGFloat columnWidth;
@property (nonatomic) NSUInteger numberOfColumns;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) NSMutableArray* layoutAttributes;  // array of UICollectionViewLayoutAttributes
@property (nonatomic, strong) NSMutableArray* pendingLayoutAttributes;
@end
