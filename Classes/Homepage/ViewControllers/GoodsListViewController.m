//
//  GoodsListViewController.m
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsModel.h"
#import "GoodsListApi.h"
#import "GoodsCollectionViewAgent.h"
#import "QQWRefreshHeader.h"
#import "QQWRefreshFooter.h"

@interface GoodsListViewController ()<ApiRequestDelegate>

@property (nonatomic, strong) GoodsListApi *listApi;

@property (nonatomic, strong) GoodsCollectionViewAgent *agent;

@property (nonatomic, strong) NSMutableArray *dataArray;



@end

@implementation GoodsListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listApi.sortId = self.sortId;
    self.listApi.brandId = self.brandId;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kLoginSuccessNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kLogoutSuccessNotify object:nil];
    
    __weak typeof(self) wself = self;
    self.agent.collectionView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.listApi refresh];
    }];
    
    self.agent.collectionView.mj_footer = [QQWRefreshFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.listApi loadNextPage];
    }];
    QQWRefreshFooter *footer = (QQWRefreshFooter *)self.agent.collectionView.mj_footer;
    [footer setFooterNoMoreView:[[QQWRefreshNoMoreView alloc] init]];
    
    [self.view addSubview:self.agent.collectionView];
    [self.agent.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    [self.agent.collectionView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.eventStatisticsId) {
        [MobClick event:self.eventStatisticsId];
    }
}

- (void)notificationRecieved:(NSNotification *)note {
    if ([note.name isEqualToString:kLoginSuccessNotify] ||
        [note.name isEqualToString:kLogoutSuccessNotify]) {
        [self.agent.collectionView.mj_header beginRefreshing];
    }
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
- (GoodsListApi *)listApi {
    if (!_listApi) {
        _listApi = [[GoodsListApi alloc] init];
        _listApi.delegate = self;
    }
    return _listApi;
}

- (GoodsCollectionViewAgent *)agent {
    if (!_agent) {
        _agent = [[GoodsCollectionViewAgent alloc] initWithParentViewController:self];
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
