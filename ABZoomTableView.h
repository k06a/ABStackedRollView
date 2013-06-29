//
//  ABZoomTableView.h
//  ABZoomTableView
//
//  Created by Антон Буков on 29.06.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABZoomTableView : UITableView
@property (nonatomic, copy) UIView * (^cellSubviewForTransformation)(UITableViewCell * cell);
@end
