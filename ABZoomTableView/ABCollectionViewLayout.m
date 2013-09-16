//
//  ABCollectionViewLayout.m
//  ABZoomTableView
//
//  Created by Антон Буков on 16.09.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import "ABCollectionViewLayout.h"

@interface ABCollectionViewLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;

@end

@implementation ABCollectionViewLayout

- (void)prepareLayout
{
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger totalIndex = 0;
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sectionCount; section++)
    {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = CGRectMake(0,totalIndex*50,self.collectionView.bounds.size.width,50);
            
            cellLayoutInfo[indexPath] = itemAttributes;
            totalIndex++;
        }
    }
    
    self.layoutInfo = cellLayoutInfo;
}

- (CGSize)collectionViewContentSize
{
    NSInteger totalCount = 0;
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sectionCount; section++)
        totalCount += [self.collectionView numberOfItemsInSection:section];
    
    return CGSizeMake(self.collectionView.bounds.size.width, 50*totalCount);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop)
    {
        if (CGRectIntersectsRect(rect, attributes.frame))
            [allAttributes addObject:attributes];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[indexPath];
}

@end
