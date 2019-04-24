//
//  SortViewController.m
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "SortViewController.h"
#import "SortApi.h"
#import "SortCell.h"
#import "SortListItem.h"
#import "QQWRefreshHeader.h"
#import "GoodsListViewController.h"

@interface SortViewController ()<ApiRequestDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SortApi *api;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself =wself;
        [sself.api getGoodsCategory];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [Utils removeHudFromView:self.view];
    [self.tableView.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableView];
    
    self.dataArray = responsObject;
    [self.tableView reloadData];
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils removeHudFromView:self.view];
    [self.tableView.mj_header endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
    
    if (self.dataArray.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.tableView response:command.response operationBlock:^{
            strongify(self)
            [self.tableView.mj_header beginRefreshing];
        }];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SortListItem *item = [self.dataArray safeObjectAtIndex:indexPath.row];
    return [SortCell heithForSortItem:item];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SortCell *cell = (SortCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SortCell class])];
    
    SortListItem *item = [self.dataArray safeObjectAtIndex:indexPath.row];
    [cell refreshWithSortItem:item];
    
    __weak typeof(self) wself = self;
    cell.sortJumpBlock = ^(SortListItem *sortItem) {
        __strong typeof(wself) sself = wself;
        [sself jumpToGoodsListWithSort:sortItem];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -
- (void)setShouldScrollToTop:(BOOL)scrollToTop {
    self.tableView.scrollsToTop = scrollToTop;
}

#pragma mark - 
- (void)jumpToGoodsListWithSort:(SortListItem *)sortItem {
    GoodsListViewController *vc = [[GoodsListViewController alloc] init];
    vc.sortId = sortItem.cat_id;
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = sortItem.cat_name;
    vc.eventStatisticsId = kEventSortListPage;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Properties
- (SortApi *)api {
    if (!_api) {
        _api = [[SortApi alloc] init];
        _api.delegate = self;
    }
    return _api;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[SortCell class] forCellReuseIdentifier:NSStringFromClass([SortCell class])];
    }
    return _tableView;
}

@end
