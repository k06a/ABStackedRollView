//
//  ABZoomTableView.h
//  ABZoomTableView
//
//  Created by Антон Буков on 29.06.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABZoomTableCollectionView : UICollectionView
@property (nonatomic, copy) UIView * (^cellSubviewForTransformation)(UICollectionViewCell * cell);
@end
