//
//  ViewController.m
//  Board
//
//  Created by CoolKernel on 6/16/16.
//  Copyright © 2016 CoolKernel. All rights reserved.
//

#import "ViewController.h"
#import "MHCollectionView.h"
#import "MHCollectionViewCell.h"

#define Size ([UIScreen mainScreen].bounds.size)

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) MHCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [@[] mutableCopy];
    NSInteger count = 1;
    while (count <= 10) {
        NSString *str = [NSString stringWithFormat:@"%ld.jpg", (long)count];
        [self.dataArray addObject:str];
        count ++;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(Size.width / 3, (Size.width / 3) / 3 * 4);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[MHCollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerMoveAction];
    _collectionView.dataSourceArr = self.dataArray;
    [_collectionView registerClass:[MHCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //120:160
    
    MHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.data = _dataArray[indexPath.row];
    
    return cell;
}





@end
