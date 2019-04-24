//
//  ShopCollectViewController.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "ShopCollectViewController.h"
#import "ShopModel.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import "HomepageViewController.h"
#import "ShopCellTableViewCell.h"
#import "QQWRefreshHeader.h"
#import "GoodsDetailViewController.h"
@interface ShopCollectViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UITableView *TableView;
@property (nonatomic,strong)NSMutableArray *shopModelArr;
@property (nonatomic,assign)int page;

@end

@implementation ShopCollectViewController

static NSString* shopCell = @"shopTableViewCell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.TableView.backgroundColor = DefaultBackgroundColor;
    
}
- (UITableView *)TableView{
    if (!_TableView) {
        _TableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_TableView];
        [_TableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        self.TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _TableView.delegate = self;
        _TableView.dataSource = self;
        [_TableView registerClass:[ShopCellTableViewCell class] forCellReuseIdentifier:shopCell];

    }
    return _TableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.navigationController.navigationBarHidden = NO;

    __weak typeof(self) wself = self;
    _shopModelArr = [NSMutableArray new];
    self.TableView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        sself.page = 1;
        [self request];
    }];
    
    self.TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        sself.page ++;
        [self request];
    }];
    
    [self.TableView.mj_header beginRefreshing];
}

-(void)request{
    [ShopModel requestShopListWithDataArray:_shopModelArr page:_page superView:nil finshBlock:^(id obj, NSError *error) {
        [self.TableView.mj_header endRefreshing];
        [self.TableView.mj_footer endRefreshing];
      
        if (_shopModelArr.count <= 0) {
            [[EmptyManager sharedManager] showEmptyOnView:self.TableView withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"收藏还是空的" operationText:nil operationBlock:nil];
        }
          [_TableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _shopModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCell];
    ShopModel *model = [_shopModelArr objectAtIndex:indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];

    [_TableView setEditing:editing animated:animated];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        
        ShopModel *model =  [self.shopModelArr objectAtIndex:indexPath.row];
        [ShopModel requestShopWithGoodsId:model.goods_id type:1 superView:self.view finshBlock:^(id obj, NSError *error) {
            if (!error) {
                [self.shopModelArr removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                if (self.shopModelArr.count <= 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[EmptyManager sharedManager] showEmptyOnView:self.TableView withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"收藏还是空的" operationText:nil operationBlock:nil];
                    });
                    
                }
            }
        }];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ShopModel *model = [self.shopModelArr objectAtIndex:indexPath.row];
    
    GoodsDetailViewController *good = [[GoodsDetailViewController alloc]initWithGoodsIdentifier:model.goods_id];
    good.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:good animated:YES];

}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
}



@end
