ABZoomTableView
===============

Simple `UITableView` son, witch zoom-in cells near center.

<img src="https://raw.github.com/k06a/ABZoomTableView/master/ABZoomTableView-screenshot.png" width="50%" />

Usage
===============

You just need to assign block for determining subview to zoom:


```
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.cellSubviewForTransformation = ^UIView*(UITableViewCell * cell) {
        return [cell viewWithTag:1];
    };
}
```
