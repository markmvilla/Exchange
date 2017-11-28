//
//  FavoritesPostViewLayout.m
//  TCUExchange
//
//  Created by Mark Villa on 3/11/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "FavoritesPostViewLayout.h"
@implementation FavoritesPostViewLayout

- (id)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        self.contentSize = CGSizeZero;
        self.leftRightInset= 3;
        self.topInset = 10;
        self.bottomInset = 40;
        self.lineSpacing = 10.0;
        // interitemSpacing should be even
        self.interitemSpacing = 10.0;
        self.itemHeight = 180.0;
        self.numberOfColumns = 1;
        self.columnWidth = (view.bounds.size.width - self.leftRightInset*2 - self.interitemSpacing*(self.numberOfColumns-1))/self.numberOfColumns;
    }
    return self;
}

#pragma mark - UIFavoritesPostViewLayout
- (void)prepareLayout {
    [super prepareLayout];
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    [self doNewLayout];
    self.layoutAttributes = self.pendingLayoutAttributes;
    // create a predicate to find cells that intersect with the passed rectangle, then use it to filter the array of layout attributes
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary* bindings) {
        UICollectionViewLayoutAttributes* layoutAttributes = evaluatedObject;
        CGRect cellFrame = layoutAttributes.frame;
        return CGRectIntersectsRect(cellFrame,rect);
    }];
    NSArray* filteredLayoutAttributes = [self.layoutAttributes filteredArrayUsingPredicate:predicate];
    // return the filtered array
    return filteredLayoutAttributes;
}

#pragma mark - Private Instance Methods
- (void)doNewLayout {
    id<UIFavoritesPostViewLayoutDelegate> delegate = (id<UIFavoritesPostViewLayoutDelegate>)self.collectionView.delegate;
    NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    NSUInteger maximumNumberOfColumns = self.numberOfColumns;
    self.pendingLayoutAttributes = [NSMutableArray arrayWithCapacity:cellCount];
    // will need an array of column heights
    CGFloat* columnHeights = calloc(maximumNumberOfColumns,sizeof(CGFloat));
    for(NSUInteger col = 0; col < maximumNumberOfColumns; ++col) {
        columnHeights[col] += self.topInset;
    }
    CGFloat contentHeight = 0.0;
    CGFloat contentWidth = 0.0;
    NSUInteger columnWidth = self.columnWidth;
    // logic for attributes
    for(NSUInteger cellIndex = 0; cellIndex < cellCount; ++cellIndex) {
        CGFloat itemHeight = 0.0;
        if(delegate && [delegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:)]){
            itemHeight = [delegate collectionView:self.collectionView
                                           layout:self
                         heightForItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex inSection:0]];
        }
        NSUInteger useColumn = 0;
        CGFloat shortestHeight = DBL_MAX;
        for(NSUInteger col = 0; col < maximumNumberOfColumns; ++col) {
            if(columnHeights[col] < shortestHeight) {
                useColumn = col;
                shortestHeight = columnHeights[col];
            }
        }

        // adding attributes
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:cellIndex inSection:0];
        UICollectionViewLayoutAttributes* layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        layoutAttributes.size = CGSizeMake(columnWidth,itemHeight);
        layoutAttributes.center = CGPointMake((useColumn*(columnWidth+self.interitemSpacing))+self.leftRightInset+(columnWidth/2.0), columnHeights[useColumn]+(itemHeight/2.0));
        self.pendingLayoutAttributes[cellIndex] = layoutAttributes;

        // keep calculating greatest height and width for contentSize
        columnHeights[useColumn] += itemHeight;
        //NSLog(@"%f > %f", columnHeights[useColumn], contentHeight);
        if(columnHeights[useColumn] > contentHeight){
            contentHeight = columnHeights[useColumn];
        }
        CGFloat rightEdge = (useColumn * (columnWidth + self.interitemSpacing)) + self.leftRightInset *2 + columnWidth;
        //NSLog(@"%f > %f", rightEdge, contentWidth);
        if(rightEdge > contentWidth){
            contentWidth = rightEdge;
        }
        columnHeights[useColumn] += self.lineSpacing;

    }
    //NSLog(@"%@", NSStringFromCGSize(CGSizeMake(contentWidth,contentHeight)));
    self.contentSize = CGSizeMake(contentWidth,contentHeight);

    free(columnHeights);
}

@end
