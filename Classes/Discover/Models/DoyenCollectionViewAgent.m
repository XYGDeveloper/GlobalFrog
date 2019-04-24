//
//  DoyenCollectionViewAgent.m
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "DoyenCollectionViewAgent.h"
#import "DoyenListCell.h"
#import "DoyenSectionHeader.h"
#import "DoyenSectionFooter.h"
#import "DoyenSubListViewController.h"
#import "DoyenArticleListViewController.h"
#import "DoyenListItem.h"

#import "AttentionModel.h"

@interface DoyenCollectionViewAgent ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, readwrite) UICollectionView *collectionView;

@property (nonatomic, weak) UIViewController *parentVC;

@property (nonatomic, strong) NSArray *dataArray;



@property (nonatomic,assign) BOOL flage;

@end

@implementation DoyenCollectionViewAgent


- (id)initWithParentViewController:(UIViewController *)parentViewController {
    if (self = [super init]) {
        self.shouldGroup = YES;
        self.parentVC = parentViewController;
           [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeGZSte:) name:KNOTIFY_CHANGE_HT5_REFRESH object:nil];
        [self.collectionView registerClass:[DoyenListCell class] forCellWithReuseIdentifier:NSStringFromClass([DoyenListCell class])];
        [self.collectionView registerClass:[DoyenSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([DoyenSectionHeader class])];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        [self.collectionView registerClass:[DoyenSectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([DoyenSectionFooter class])];
    }
    return self;
}

#pragma mark ================== noty =================
-(void)changeGZSte:(NSNotification* )noty{
    NSString * s = noty.object;
    NSArray * a = [s componentsSeparatedByString:@","];
//    NSLog(@"%@,%@",a,self.dataArray.mj_keyValues);
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DoyenListItem * dList = obj;
        [dList.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DoyenItem * doy = obj;
            if ([doy.uid isEqualToString:a[0]]) {
                doy.isFollow = a[1];
                if (doy.isFollow.intValue == 1) {
                    doy.follows = [NSString stringWithFormat:@"%i",doy.follows.intValue+1];
                }else{
                    doy.follows = [NSString stringWithFormat:@"%i",doy.follows.intValue-1];
                }
                *stop = YES;
                return ;
            }
        }];
    }];
 
    [self.collectionView reloadData];
}

#pragma mark - Public Methods
- (void)reloadWithItems:(NSArray *)itemArray {
    self.dataArray = itemArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.shouldGroup ? self.dataArray.count : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.shouldGroup) {
        DoyenListItem *listItem = [self.dataArray safeObjectAtIndex:section];
        return listItem.list.count;
    } else {
        return self.dataArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DoyenListCell *cell = (DoyenListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DoyenListCell class]) forIndexPath:indexPath];
    DoyenItem *item = [self topicItemAtIndexPath:indexPath];
    [cell refreshWithListItem:item];
    
    weakify(cell);
    cell.attention = ^(DoyenItem *item1){
        if (![Utils showLoginPageIfNeeded]) {
            strongify(cell);
            cell.attentionButton.selected = !cell.attentionButton.selected;
            cell.attentionState.selected = !cell.attentionState.selected;
            NSLog(@"%@  %i",[item1 mj_keyValues],_flage);

            [AttentionModel requestAttentuonWithFuid:item1.userid type:item1.isFollow.intValue superView:nil finshBlock:^(id obj, NSError *error) {
                if (item1.isFollow.intValue == 0) {
                    item1.isFollow = @"1";
                    item1.follows = [NSString stringWithFormat:@"%i",item1.follows.intValue+1];
                    [cell.attentionButton setBackgroundImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateSelected];
                    [cell.attentionState setBackgroundImage:[UIImage imageNamed:@"Dayen_attention_selected"] forState:UIControlStateSelected];
                    cell.attentionState.selected = YES;
                }else{
                    item1.isFollow = @"0";
                    item1.follows = [NSString stringWithFormat:@"%i",item1.follows.intValue-1];
                    [cell.attentionButton setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
                    [cell.attentionState setBackgroundImage:[UIImage imageNamed:@"Dayen_attention_normal"] forState:UIControlStateNormal];
                    cell.attentionState.selected = NO;
                    
                }
                [self.collectionView reloadData];
            }];
            
        }
        
    };
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.shouldGroup) {
        //正常分组头部
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            DoyenSectionHeader *header = (DoyenSectionHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([DoyenSectionHeader class]) forIndexPath:indexPath];
            
            DoyenListItem *listItem = [self.dataArray safeObjectAtIndex:indexPath.section];
            [header refreshWithName:listItem.name];
            
            __weak typeof(self) wself = self;
            header.actionBlock = ^ {
                __strong typeof(wself) sself = wself;
                [sself jumpToSubTopicList:listItem];
            };
            
            return header;
        }
        else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            //最后底部一个成为达人的底部
            if (indexPath.section == self.dataArray.count - 1) {
                DoyenSectionFooter *footer = (DoyenSectionFooter *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([DoyenSectionFooter class]) forIndexPath:indexPath];
                __weak typeof(self) wself = self;
                footer.clickBlock = ^ {
                    __strong typeof(wself) sself = wself;
                    WebViewController *vc = [[WebViewController alloc] initWithURLString:H5URL(@"/app-doyen/apply")];
                    vc.useHtmlTitle = YES;
                    vc.hidesBottomBarWhenPushed = YES;
                    [sself.parentVC.navigationController pushViewController:vc animated:YES];
                };
                return footer;
            }
            //正常分组底部，用作分隔
            else {
                UICollectionReusableView *footer = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
                footer.backgroundColor = DefaultBackgroundColor;
                return footer;
            }
        }
    }
    
    
    UICollectionReusableView *header = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
    
    return header;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DoyenItem *dayenItem = [self topicItemAtIndexPath:indexPath];
    DoyenArticleListViewController *vc = [[DoyenArticleListViewController alloc] initWithTopicIdentifier:dayenItem.doyen_id];
    vc.title = dayenItem.nickname;
    vc.hidesBottomBarWhenPushed = YES;
    [self.parentVC.navigationController pushViewController:vc animated:YES];
    
    
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.shouldGroup) {
        return CGSizeMake(kScreenWidth, 50.0);
    } else {
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.shouldGroup && section < self.dataArray.count - 1) {
        return CGSizeMake(kScreenWidth, 18.0);
    } else if (self.shouldGroup && section == self.dataArray.count - 1) {
        return [DoyenSectionFooter footerSize];
    } else {
        return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.shouldGroup) {
        return UIEdgeInsetsMake(0, 10.0, 10.0, 10.0);
    } else {
        return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    }
}


#pragma mark - Pravite Methods
- (DoyenItem *)topicItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.shouldGroup) {
        DoyenListItem *listItem = [self.dataArray safeObjectAtIndex:indexPath.section];
        return [listItem.list safeObjectAtIndex:indexPath.row];
    } else {
        return [self.dataArray safeObjectAtIndex:indexPath.row];
    }
}

//跳转到发现专题二级页
- (void)jumpToSubTopicList:(DoyenListItem *)listItem {
    DoyenSubListViewController *vc = [[DoyenSubListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = listItem.name;
    vc.doyen_type = listItem.doyen_type;
    [self.parentVC.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - properties
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        TopicCollectionViewFlowLayout *layout = [[TopicCollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

@end




@implementation TopicCollectionViewFlowLayout

- (id)init {
    
    if (self = [super init]) {
        self.itemSize = [DoyenListCell cellItemSize];
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
    }
    return self;
}





@end
