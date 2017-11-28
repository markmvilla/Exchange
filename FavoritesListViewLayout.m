//
//  FavoritesListViewLayout.m
//  TCUExchange
//
//  Created by Mark Villa on 3/11/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "FavoritesListViewLayout.h"
@implementation FavoritesListViewLayout

- (id)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        self.contentSize = CGSizeZero;
        self.itemHeight = 150.0;
        self.itemWidth = 100.0;
        self.verticleOuterInset = 1;
        self.verticleInnerInset = 10;
        self.horizontalOuterInset = 2;
        self.horizontalInnerInset = 10;
    }
    return self;
}

#pragma mark - UIFavoritesListViewLayout
- (void)prepareLayout {
    [super prepareLayout];
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    [self initializeLayout];
    self.layoutAttributes = self.pendingLayoutAttributes;
    // create a predicate to find cells that intersect with the passed rectangle, then use it to filter the array of layout attributes
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary* bindings) {
        UICollectionViewLayoutAttributes* layoutAttributes = evaluatedObject;
        CGRect cellFrame = layoutAttributes.frame;
        return CGRectIntersectsRect(cellFrame,rect);
    }];
    NSArray* filteredLayoutAttributes = [self.layoutAttributes filteredArrayUsingPredicate:predicate];
    return filteredLayoutAttributes;
}

#pragma mark - Private Instance Methods
- (void)initializeLayout {
    NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    self.pendingLayoutAttributes = [NSMutableArray arrayWithCapacity:cellCount];

    CGFloat contentHeight = 2*self.verticleOuterInset+self.itemHeight;
    CGFloat contentWidth;
    if(cellCount<1){
        contentWidth = 2*self.horizontalOuterInset;
    }
    else{
        contentWidth = 2*self.horizontalOuterInset+cellCount*self.itemWidth+(cellCount-1)*self.horizontalInnerInset;
    }
    self.contentSize = CGSizeMake(contentWidth,contentHeight);

    // logic for attributes
    for(NSUInteger cellIndex = 0; cellIndex < cellCount; ++cellIndex) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:cellIndex inSection:0];
        UICollectionViewLayoutAttributes* layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        layoutAttributes.size = CGSizeMake(self.itemWidth,self.itemHeight);
        layoutAttributes.center = CGPointMake(self.horizontalOuterInset+cellIndex*(self.itemWidth+self.horizontalInnerInset)+self.itemWidth/2, self.verticleOuterInset+self.itemHeight/2);
        self.pendingLayoutAttributes[cellIndex] = layoutAttributes;
    }
}

@end
