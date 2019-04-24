//
//  PrivateMessageViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/14.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "PrivateMessageViewController.h"
#import "PrivateMsgApi.h"
#import "PrivateTableViewCell.h"
#import "PrivateMsgModel.h"
#import "MessageViewController.h"
@interface PrivateMessageViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) PrivateMsgApi *api;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PrivateMessageViewController
static NSString *cellID = @"cellID";

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[PrivateTableViewCell class] forCellReuseIdentifier:cellID];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
       [sself.api refresh];
        
    }];
    
    self.tableView.mj_footer = [QQWRefreshFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api loadNextPage];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
    });
   
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableView];
    
    if (api == _api) {
        NSArray *array = (NSArray *)responsObject;
        if (array.count <= 0) {
            [[EmptyManager sharedManager] showEmptyOnView:self.tableView withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"暂时没有消息哦" operationText:@"" operationBlock:nil];
        } else {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:responsObject];
            [self.tableView reloadData];
        }
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils removeHudFromView:self.view];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
    
    if (self.dataArray.count <= 0) {
        
        [[EmptyManager sharedManager] showNetErrorOnView:self.tableView response:command.response operationBlock:nil];
    }
}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
    [self.dataArray addObjectsFromArray:responsObject];
    [self.tableView reloadData];
    
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
    
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrivateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    PrivateMsgModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;

    return cell;
}

#pragma mark - Properties
- (PrivateMsgApi *)api{
    if (!_api) {
        _api = [[PrivateMsgApi alloc] init];
        _api.delegate = self;
    }
    return _api;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    PrivateMsgModel *model = [_dataArray objectAtIndex:indexPath.row];
    MessageViewController *detail = [[MessageViewController alloc]init];
     detail.uid = model.uid;
    detail.title = [NSString stringWithFormat:@"与%@私聊", model.nickname];
    [self.navigationController pushViewController:detail animated:YES];

}



@end
