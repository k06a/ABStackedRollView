//
//  ABViewController.m
//  ABZoomTableView
//
//  Created by Антон Буков on 29.06.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import "ABViewController.h"
#import "ABZoomTableView.h"

@interface ABViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet ABZoomTableView *tableView;
@end

@implementation ABViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_1"];
    
    UIButton * button = (id)[cell viewWithTag:1];
    button.highlighted = YES;
    [button setTitle:[@(indexPath.row) description]
            forState:(UIControlStateNormal)];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.cellSubviewForTransformation = ^UIView*(UITableViewCell * cell) {
        return [cell viewWithTag:1];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
