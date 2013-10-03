ABStackedRollView
===============

Simple `UICollectionView` son, witch creates visual stacks.

<img src="https://raw.github.com/k06a/ABZoomTableView/master/ABZoomTableView-screenshot.png" width="50%" />

Usage
===============

1. Use `ABStackedRollView` class in xib, storyboard or in code as `UICollectionView`

2. Create collection view with cell width equal to collection view width

3. Increase collection view size 3x times vertically (items will be in the middle 1/3)

4. Assign block for determining subview to zoom:


```

    self.stackedRollView.cellSubviewForTransformation = ^UIView*(UICollectionViewCell * cell) {
        return [cell.contentView viewWithTag:1];
    };
}
```
