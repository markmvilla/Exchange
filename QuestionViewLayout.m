//
//  QuestionViewLayout.m
//  TCUExchange
//
//  Created by Mark Villa on 3/11/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "QuestionViewLayout.h"
@implementation QuestionViewLayout

-(id)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        //NSLog(@"initlayout");
        //self.contentSize = view.frame.size;
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
        //NSLog(@"columnWidth: %f", self.columnWidth);
    }
    return self;
}

#pragma mark - UIQuestionViewLayout
-(void)prepareLayout {
    //NSLog(@"4:prepareLayout");
    [super prepareLayout];
}

-(CGSize)collectionViewContentSize {
    //NSLog(@"5:collectionViewContentSize: %f", self.contentSize);
    return self.contentSize;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    //NSLog(@"6:layoutAttributesForElementsInRect");
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
-(void)doNewLayout {
    id<UIQuestionViewLayoutDelegate> delegate = (id<UIQuestionViewLayoutDelegate>)self.collectionView.delegate;
    // find out how many cells there are
    NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    // get max number of columns from our property
    NSUInteger maximumNumberOfColumns = self.numberOfColumns;
    // now build the array of layout attributes
    self.pendingLayoutAttributes = [NSMutableArray arrayWithCapacity:cellCount];
    // will need an array of column heights
    CGFloat* columnHeights = calloc(maximumNumberOfColumns,sizeof(CGFloat));
    for(NSUInteger col = 0; col < maximumNumberOfColumns; ++col) {
        columnHeights[col] += self.topInset;
    }
    CGFloat contentHeight = 0.0;
    CGFloat contentWidth = 0.0;
    // get width from our property
    NSUInteger columnWidth = self.columnWidth;
    // logic for attributes
    for(NSUInteger cellIndex = 0; cellIndex < cellCount; ++cellIndex) {
        //NSLog(@"cellindex is now: %lu", (unsigned long)cellIndex);
        CGFloat itemHeight = 0.0;
        if(delegate && [delegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:)]){
            itemHeight = [delegate collectionView:self.collectionView
                                           layout:self
                         heightForItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex inSection:0]];
        }
        NSUInteger useColumn = 0;
        CGFloat shortestHeight = /*DBL_MAX*/ 234667245436234;
        for(NSUInteger col = 0; col < maximumNumberOfColumns; ++col) {
            //NSLog(@"columnHeights[%lu]: %f vs shortestHeight: %f",(unsigned long)col,columnHeights[col], shortestHeight);
            if(columnHeights[col] < shortestHeight) {
                useColumn = col;
                shortestHeight = columnHeights[col];
            }
        }
        // adding attributes
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:cellIndex inSection:0];
        UICollectionViewLayoutAttributes* layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        layoutAttributes.size = CGSizeMake(columnWidth,itemHeight);
        //layoutAttributes.center = CGPointMake((useColumn * (columnWidth + self.interitemSpacing)) + (columnWidth / 2.0),columnHeights[useColumn] + (itemHeight / 2.0));
        layoutAttributes.center = CGPointMake((useColumn*(columnWidth+self.interitemSpacing))+self.leftRightInset+(columnWidth/2.0), columnHeights[useColumn]+(itemHeight/2.0));
        self.pendingLayoutAttributes[cellIndex] = layoutAttributes;
        // keep calculating greatest height and width for contentSize
        columnHeights[useColumn] += itemHeight;
        //NSLog(@"%f > %f", columnHeights[useColumn], contentHeight);
        if(columnHeights[useColumn] > contentHeight){
            //NSLog(@"columnHeights");
            contentHeight = columnHeights[useColumn];
        }
        CGFloat rightEdge = (useColumn * (columnWidth + self.interitemSpacing)) + self.leftRightInset *2 + columnWidth;
        //NSLog(@"%f > %f", rightEdge, contentWidth);
        if(rightEdge > contentWidth){
            //NSLog(@"rightEdge");
            contentWidth = rightEdge;
        }
        columnHeights[useColumn] += self.lineSpacing;
    }
    self.contentSize = CGSizeMake(contentWidth,contentHeight);

    free(columnHeights);
}

@end
