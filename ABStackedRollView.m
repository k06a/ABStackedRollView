//
//  ABZoomTableView.m
//  ABZoomTableView
//
//  Created by Anton Bukov on 29.06.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import "ABStackedRollView.h"

#pragma mark - ABZoomTableViewProxy

@interface ABStackedRollViewProxy : NSObject<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) id<UICollectionViewDataSource> anotherDataSource;
@property (nonatomic, weak) id<UICollectionViewDelegate> anotherDelegate;
@property (nonatomic, weak) UICollectionView * collectionView;
@property (nonatomic, copy) UIView * (^cellSubviewForTransformation)(UICollectionViewCell * cell);
@end

@implementation ABStackedRollViewProxy

- (id)initWithTableView:(UICollectionView *)collectionView
{
    if (self = [super init])
    {
        self.collectionView = collectionView;
    }
    return self;
}

- (void)scrollViewDidScroll:(UICollectionView *)collectionView
{
    for (NSIndexPath * ip in [[collectionView indexPathsForVisibleItems] sortedArrayUsingSelector:@selector(compare:)])
    {
        UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:ip];
        UIView * view = self.cellSubviewForTransformation(cell);
        
        CGFloat offset = collectionView.contentOffset.y + collectionView.contentInset.top - (cell.frame.origin.y - cell.frame.size.height);
        CGFloat offset2 = -(collectionView.contentOffset.y + collectionView.frame.size.height - collectionView.contentInset.bottom -  (cell.frame.origin.y + 2*cell.frame.size.height));
        
        BOOL first = (offset > 0);
        BOOL second = (offset2 > 0);
        
        if (second)
            [cell.superview sendSubviewToBack:cell];
        else
            [cell.superview bringSubviewToFront:cell];
        
        if (!first && !second)
        {
            view.transform = CGAffineTransformIdentity;
            continue;
        }
        
        if (second)
            offset = offset2;
            
        CGFloat k1 = (7 + ((100 - offset) / 100))/8;
        CGFloat k2 = MAX(0,offset - pow(offset,1./3.)*7);
        view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0,(second?-k2:k2)),k1,k1);
    }
    
    if ([self.anotherDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.anotherDelegate scrollViewDidScroll:collectionView];
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
        return [ABStackedRollViewProxy instanceMethodSignatureForSelector:aSelector];
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

@interface ABStackedRollView ()
@property (nonatomic, strong) ABStackedRollViewProxy * dataSourceAndDelegate;
@end

@implementation ABStackedRollView

#pragma mark - Properties

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setContentInset:UIEdgeInsetsMake(frame.size.height/3, 0, frame.size.height/3, 0)];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self setContentInset:UIEdgeInsetsMake(bounds.size.height/3, 0, bounds.size.height/3, 0)];
}

#pragma mark - Init methods

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
        [self setFrame:frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
        [self setFrame:super.frame];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.dataSourceAndDelegate scrollViewDidScroll:self];
}

- (ABStackedRollViewProxy *)dataSourceAndDelegate
{
    if (_dataSourceAndDelegate == nil)
        _dataSourceAndDelegate = [[ABStackedRollViewProxy alloc] initWithTableView:self];
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
