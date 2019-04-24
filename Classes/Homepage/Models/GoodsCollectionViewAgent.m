//
//  GoodsCollectionViewAgent.m
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "GoodsCollectionViewAgent.h"
#import "FavApi.h"
#import "GoodsListCell.h"
#import "GoodsModel.h"
#import "GoodsDetailViewController.h"

@interface GoodsCollectionViewAgent ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, readwrite) UICollectionView *collectionView;

@property (nonatomic, weak) UIViewController *parentVC;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) FavApiManager *favManager;

@end

@implementation GoodsCollectionViewAgent

- (id)initWithParentViewController:(UIViewController *)parentViewController {
    if (self = [super init]) {
        self.parentVC = parentViewController;
        
        [self.collectionView registerClass:[GoodsListCell class] forCellWithReuseIdentifier:NSStringFromClass([GoodsListCell class])];
    }
    return self;
}

#pragma mark - Public Methods
- (void)reloadWithItems:(NSArray *)itemArray {
    self.dataArray = itemArray;
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
    GoodsListCell *cell = (GoodsListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GoodsListCell class]) forIndexPath:indexPath];
    
    GoodsModel *goods = [self.dataArray safeObjectAtIndex:indexPath.row];
    [cell refreshWithGoods:goods];
    
    __weak typeof(self) wself = self;
    cell.favBlock = ^{
        __strong typeof(wself) sself = wself;
        [sself doFavForGoodsAtIndexPath:indexPath];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsModel *goods = [self.dataArray safeObjectAtIndex:indexPath.row];
    
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] initWithGoodsIdentifier:goods.goods_id];
    if ([self.parentVC.eventStatisticsId isEqualToString:kEventSortListPage]) {
        vc.eventStatisticsId = kEventSortGoodsDetailPage;
    }
    [self.parentVC.navigationController pushViewController:vc animated:YES];
}


#pragma makr - Private Methods
- (void)doFavForGoodsAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([Utils showLoginPageIfNeeded]) {
        return;
    }
    
    GoodsModel *goods = [self.dataArray safeObjectAtIndex:indexPath.row];
    
    NSString *goodsId = goods.goods_id ?: @"";
    
    __weak typeof(self) wself = self;
//  [ShopModel requestShopWithGoodsId:goodsId type:goods.isfav superView:self.version finshBlock:^(id obj, NSError *error) {
//      
//  }];
    [Utils addHudOnView:self.parentVC.view];
    if (goods.isfav) {
        [self.favManager deleteFavWithGoodsId:goodsId completionBlock:^(ApiCommand *cmd, BOOL success) {
            __strong typeof(wself) sself = wself;
            if (success) {
                [sself doFavSuccessForGoodsAtIndexPath:indexPath fav:NO];
            }
            
            [Utils removeHudFromView:sself.parentVC.view];
            [Utils postMessage:cmd.response.msg onView:sself.parentVC.view];
        }];
    } else {
        [self.favManager addFavWithGoodsIds:@[goodsId] completionBlock:^(ApiCommand *cmd, BOOL success) {
            __strong typeof(wself) sself = wself;
            if (success) {
                [sself doFavSuccessForGoodsAtIndexPath:indexPath fav:YES];
            }
            
            [Utils removeHudFromView:sself.parentVC.view];
            [Utils postMessage:cmd.response.msg onView:sself.parentVC.view];
        }];
    }
}

- (void)doFavSuccessForGoodsAtIndexPath:(NSIndexPath *)indexPath fav:(BOOL)isFav {
    
    GoodsModel *goods = [self.dataArray safeObjectAtIndex:indexPath.row];
    goods.isfav = isFav;
    
    NSInteger originNumber = [goods.favorite_number integerValue];
    NSInteger number = isFav ? originNumber + 1 : MAX(0, originNumber - 1);
    goods.favorite_number = [NSString stringWithFormat:@"%ld",(long)number];
    
    if (indexPath) {
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}



#pragma mark - properties
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        GoodsCollectionViewFlowLayout *layout = [[GoodsCollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.backgroundColor = DefaultBackgroundColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (FavApiManager *)favManager {
    if (!_favManager) {
        _favManager = [[FavApiManager alloc] init];
    }
    return _favManager;
}


@end



@implementation GoodsCollectionViewFlowLayout

- (id)init {
    if (self = [super init]) {
        self.itemSize = [GoodsListCell cellItemSize];
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    }
    return self;
}

@end
