//
//  BrandFactoryCollectionViewAgent.m
//  Qqw
//
//  Created by zagger on 16/9/9.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BrandFactoryCollectionViewAgent.h"
#import "BrandFatoryListCell.h"
#import "BrandFactory.h"
#import "BrandFactoryDetailViewController.h"

@interface BrandFactoryCollectionViewAgent ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, readwrite) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) UIViewController *parentVC;

@end

@implementation BrandFactoryCollectionViewAgent

- (id)initWithParentViewController:(UIViewController *)parentVC {
    if (self = [super init]) {
        self.parentVC = parentVC;
        
        [self.collectionView registerClass:[BrandFatoryListCell class] forCellWithReuseIdentifier:NSStringFromClass([BrandFatoryListCell class])];
    }
    return self;
}

- (void)refreshWithDataArray:(NSArray *)dataArray {
    self.dataArray = dataArray;
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BrandFatoryListCell *cell = (BrandFatoryListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BrandFatoryListCell class]) forIndexPath:indexPath];
    
    BrandFactory *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    [cell refreshWithBrandFactoryModel:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    BrandFactory *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    BrandFactoryDetailViewController *vc = [[BrandFactoryDetailViewController alloc] initWithBrandFactoryIdentifier:model.brand_id];
    vc.hidesBottomBarWhenPushed = YES;
    [self.parentVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Properties
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[BrandFactoryColletionViewLayout alloc] init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = DefaultBackgroundColor;
    }
    return _collectionView;
}

@end




@implementation BrandFactoryColletionViewLayout

- (id)init {
    if (self = [super init]) {
        self.itemSize = [BrandFatoryListCell cellItemSize];
        self.minimumInteritemSpacing = 11.0;
        self.minimumLineSpacing = 10.0;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

@end
