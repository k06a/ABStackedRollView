//
//  ABZoomTableView.h
//  ABZoomTableView
//
//  Created by Anton Bukov on 29.06.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABStackedRollView : UICollectionView
@property (nonatomic, copy) UIView * (^cellSubviewForTransformation)(UICollectionViewCell * cell);
@end
