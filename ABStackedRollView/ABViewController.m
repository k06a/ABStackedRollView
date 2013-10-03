//
//  ABViewController.m
//  ABZoomTableView
//
//  Created by Anton Bukov on 29.06.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import "ABViewController.h"
#import "ABStackedRollView.h"

@interface ABViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,weak) IBOutlet ABStackedRollView * collectionView;
@end

@implementation ABViewController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_item" forIndexPath:indexPath];
    
    UIView * view = (id)[cell viewWithTag:1];
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 1.0;
    
    UIButton * button = (id)[cell viewWithTag:2];
    button.userInteractionEnabled = NO;
    [button setTitle:[NSString stringWithFormat:@"Cell %i",indexPath.row]
            forState:(UIControlStateNormal)];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.cellSubviewForTransformation = ^UIView*(UICollectionViewCell * cell) {
        return [cell.contentView viewWithTag:1];
    };
}

@end
