//
//  TopicViewController.m
//  Qqw
//
//  Created by zagger on 16/9/1.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicListApi.h"
#import "TopicListCell.h"
#import "TopicItem.h"

#import "QQWRefreshHeader.h"
#import "QQWRefreshFooter.h"

#import "TopicDetailViewController.h"

@interface TopicViewController ()<ApiRequestDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TopicListApi *listApi;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"专题精选";
    
    __weak typeof(self) wself = self;
    self.tableview.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.listApi refresh];
    }];
    
    QQWRefreshFooter *footer = [QQWRefreshFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.listApi loadNextPage];
    }];
    [footer setFooterNoMoreView:[[QQWRefreshNoMoreView alloc] init]];
    self.tableview.mj_footer = footer;
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    [self.tableview.mj_header beginRefreshing];
}

#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [self.tableview.mj_footer resetNoMoreData];
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableview];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:responsObject];
    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableview.mj_header endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
    
    if (self.dataArray.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.tableview response:command.response operationBlock:^{
            strongify(self)
            [self.tableview.mj_header beginRefreshing];
        }];
    }
}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [self.tableview.mj_footer endRefreshing];
    
    [self.dataArray addObjectsFromArray:responsObject];
    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableview.mj_footer endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    [self.tableview.mj_footer endRefreshingWithNoMoreData];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicItem *item = [self.dataArray safeObjectAtIndex:indexPath.section];
    return [TopicListCell heightForTopicItem:item];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *sectionFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10.0)];
    sectionFooter.backgroundColor = [UIColor clearColor];
    return sectionFooter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicListCell *cell = (TopicListCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopicListCell class])];
    
    TopicItem *item = [self.dataArray safeObjectAtIndex:indexPath.section];
    [cell refreshWithTopicItem:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TopicItem *item = [self.dataArray safeObjectAtIndex:indexPath.section];
    TopicDetailViewController *vc = [[TopicDetailViewController alloc] initWithTopicIdentifier:item.cate_id];
    vc.title = item.name;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Properties
- (TopicListApi *)listApi {
    if (!_listApi) {
        _listApi = [[TopicListApi alloc] init];
        _listApi.delegate = self;
    }
    return _listApi;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.backgroundColor = DefaultBackgroundColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc] init];
        [_tableview registerClass:[TopicListCell class] forCellReuseIdentifier:NSStringFromClass([TopicListCell class])];
    }
    return _tableview;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
