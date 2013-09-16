//
//  ABZoomTableView.m
//  ABZoomTableView
//
//  Created by Антон Буков on 29.06.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import "ABZoomTableCollectionView.h"

#pragma mark - ABZoomTableViewProxy

@interface ABZoomTableViewProxy : NSObject<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) id<UICollectionViewDataSource> anotherDataSource;
@property (nonatomic, weak) id<UICollectionViewDelegate> anotherDelegate;
@property (nonatomic, weak) UICollectionView * collectionView;
@property (nonatomic, copy) UIView * (^cellSubviewForTransformation)(UICollectionViewCell * cell);
@end

@implementation ABZoomTableViewProxy

- (id)initWithTableView:(UICollectionView *)collectionView
{
    if (self = [super init])
    {
        self.collectionView = collectionView;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (UICollectionViewCell * cell in [self.collectionView visibleCells])
    {
        CGFloat y = cell.center.y - scrollView.contentOffset.y;
        CGFloat d = 1.0 - fabsf(y - self.collectionView.bounds.size.height/2)/(self.collectionView.bounds.size.height/2);
        CGFloat k = MAX(1.0, 1.0 + (sqrt(d))*0.4);
        
        UIView * view = self.cellSubviewForTransformation(cell);
        view.transform = CGAffineTransformMakeScale(k, k);
        if (y < self.collectionView.bounds.size.height/2)
            [cell.superview bringSubviewToFront:cell];
        else
            [cell.superview sendSubviewToBack:cell];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.anotherDataSource collectionView:collectionView numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [self.anotherDataSource collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.contentView.clipsToBounds = NO;
    cell.contentView.opaque = NO;
    cell.backgroundColor = [UIColor clearColor];
    cell.clipsToBounds = NO;
    cell.opaque = NO;
    
    UIView * view = self.cellSubviewForTransformation(cell);
    view.transform = CGAffineTransformIdentity;
    
    return cell;
}

#pragma mark Redirection calls

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector]
        || [self.anotherDataSource respondsToSelector:aSelector]
        || [self.anotherDelegate respondsToSelector:aSelector];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    return [super conformsToProtocol:aProtocol]
        || [self.anotherDataSource conformsToProtocol:aProtocol]
        || [self.anotherDelegate conformsToProtocol:aProtocol];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector])
        return [ABZoomTableViewProxy instanceMethodSignatureForSelector:aSelector];
    if ([self.anotherDataSource respondsToSelector:aSelector])
        return [[self.anotherDataSource class] instanceMethodSignatureForSelector:aSelector];
    if ([self.anotherDelegate respondsToSelector:aSelector])
        return [[self.anotherDelegate class] instanceMethodSignatureForSelector:aSelector];
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([super respondsToSelector:anInvocation.selector])
        return [anInvocation invokeWithTarget:self];
    if ([self.anotherDataSource respondsToSelector:anInvocation.selector])
        return [anInvocation invokeWithTarget:self.anotherDataSource];
    if ([self.anotherDelegate respondsToSelector:anInvocation.selector])
        return [anInvocation invokeWithTarget:self.anotherDelegate];
    
    NSLog(@"Failed invocation %@", anInvocation);
}

@end



#pragma mark - ABZoomTableView

@interface ABZoomTableCollectionView ()
@property (nonatomic, strong) ABZoomTableViewProxy * dataSourceAndDelegate;
@end

@implementation ABZoomTableCollectionView

- (void)setup
{
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
}

- (id)init
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.dataSourceAndDelegate scrollViewDidScroll:self];
}

- (ABZoomTableViewProxy *)dataSourceAndDelegate
{
    if (_dataSourceAndDelegate == nil)
        _dataSourceAndDelegate = [[ABZoomTableViewProxy alloc] initWithTableView:self];
    return _dataSourceAndDelegate;
}

- (UIView *(^)(UICollectionViewCell *))cellSubviewForTransformation
{
    return [self.dataSourceAndDelegate cellSubviewForTransformation];
}

- (void)setCellSubviewForTransformation:(UIView *(^)(UICollectionViewCell *))cellSubviewForTransformation
{
    [self.dataSourceAndDelegate setCellSubviewForTransformation:cellSubviewForTransformation];
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource
{
    self.dataSourceAndDelegate.anotherDataSource = dataSource;
    [super setDataSource:self.dataSourceAndDelegate];
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate
{
    self.dataSourceAndDelegate.anotherDelegate = delegate;
    [super setDelegate:self.dataSourceAndDelegate];
}

@end
