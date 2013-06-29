//
//  ABZoomTableView.m
//  ABZoomTableView
//
//  Created by Антон Буков on 29.06.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import "ABZoomTableView.h"

#pragma mark - ABZoomTableViewProxy

@interface ABZoomTableViewProxy : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) id<UITableViewDataSource> anotherDataSource;
@property (nonatomic, weak) id<UITableViewDelegate> anotherDelegate;
@property (nonatomic, weak) UITableView * tableView;
@property (nonatomic, copy) UIView * (^cellSubviewForTransformation)(UITableViewCell * cell);
@end

@implementation ABZoomTableViewProxy

- (id)initWithTableView:(UITableView *)tableView
{
    if (self = [super init])
    {
        self.tableView = tableView;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (UITableViewCell * cell in [self.tableView visibleCells])
    {
        CGFloat y = cell.center.y - scrollView.contentOffset.y;
        CGFloat d = 1.0 - fabsf(y - self.tableView.bounds.size.height/2)/(self.tableView.bounds.size.height/2);
        CGFloat k = MAX(1.0, 1.0 + (sqrt(d))*0.4);
        
        UIView * view = self.cellSubviewForTransformation(cell);
        view.transform = CGAffineTransformMakeScale(k, k);
        if (y < self.tableView.bounds.size.height/2)
            [cell.superview bringSubviewToFront:cell];
        else
            [cell.superview sendSubviewToBack:cell];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.anotherDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    
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

@interface ABZoomTableView ()
@property (nonatomic, strong) ABZoomTableViewProxy * dataSourceAndDelegate;
@end

@implementation ABZoomTableView

- (void)setup
{
    self.clipsToBounds = NO;
    self.separatorStyle = UITableViewCellSelectionStyleNone;
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

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
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

- (UIView *(^)(UITableViewCell *))cellSubviewForTransformation
{
    return [self.dataSourceAndDelegate cellSubviewForTransformation];
}

- (void)setCellSubviewForTransformation:(UIView *(^)(UITableViewCell *))cellSubviewForTransformation
{
    [self.dataSourceAndDelegate setCellSubviewForTransformation:cellSubviewForTransformation];
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    self.dataSourceAndDelegate.anotherDataSource = dataSource;
    [super setDataSource:self.dataSourceAndDelegate];
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    self.dataSourceAndDelegate.anotherDelegate = delegate;
    [super setDelegate:self.dataSourceAndDelegate];
}

@end
