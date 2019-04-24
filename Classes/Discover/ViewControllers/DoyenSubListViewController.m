//
//  DoyenSubListViewController.m
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "DoyenSubListViewController.h"
#import "DoyenSubListApi.h"
#import "DoyenCollectionViewAgent.h"

#import "QQWRefreshHeader.h"
#import "QQWRefreshFooter.h"

@interface DoyenSubListViewController ()<ApiRequestDelegate>

@property (nonatomic, strong) DoyenSubListApi *listApi;

@property (nonatomic, strong) DoyenCollectionViewAgent *agent;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DoyenSubListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) wself = self;
    self.agent.collectionView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.listApi refresh];
    }];
    
    self.agent.collectionView.mj_footer = [QQWRefreshFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.listApi loadNextPage];
    }];
    
    [self.view addSubview:self.agent.collectionView];
    [self.agent.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    [self.agent.collectionView.mj_header beginRefreshing];
}


#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [self.agent.collectionView.mj_footer resetNoMoreData];
    [self.agent.collectionView.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.agent.collectionView];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:responsObject];
    [self.agent reloadWithItems:self.dataArray];
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.agent.collectionView.mj_header endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
    
    if (self.dataArray.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.agent.collectionView response:command.response operationBlock:^{
            strongify(self)
            [self.agent.collectionView.mj_header beginRefreshing];
        }];
    }
}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [self.agent.collectionView.mj_footer endRefreshing];
    
    [self.dataArray addObjectsFromArray:responsObject];
    [self.agent reloadWithItems:self.dataArray];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.agent.collectionView.mj_footer endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    [self.agent.collectionView.mj_footer endRefreshingWithNoMoreData];
}


#pragma mark - Properties
- (DoyenSubListApi *)listApi {
    if (!_listApi) {
        _listApi = [[DoyenSubListApi alloc] initWithDoyenType:self.doyen_type];
        _listApi.delegate = self;
    }
    return _listApi;
}

- (DoyenCollectionViewAgent *)agent {
    if (!_agent) {
        _agent = [[DoyenCollectionViewAgent alloc] initWithParentViewController:self];
        _agent.shouldGroup = NO;
    }
    return _agent;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
    
}

@end
