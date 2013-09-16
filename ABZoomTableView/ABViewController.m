//
//  ABViewController.m
//  ABZoomTableView
//
//  Created by Антон Буков on 29.06.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import "ABViewController.h"
#import "ABZoomTableCollectionView.h"

@interface ABViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,weak) IBOutlet ABZoomTableCollectionView * collectionView;
@end

@implementation ABViewController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_item" forIndexPath:indexPath];
    
    UIButton * button = (id)[cell viewWithTag:1];
    [button setTitle:[@(indexPath.row) description]
            forState:(UIControlStateNormal)];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.cellSubviewForTransformation = ^UIView*(UICollectionViewCell * cell) {
        return [cell viewWithTag:1];
    };
}

@end
