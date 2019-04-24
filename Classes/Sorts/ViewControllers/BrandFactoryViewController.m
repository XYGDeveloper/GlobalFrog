//
//  BrandFactoryViewController.m
//  Qqw
//
//  Created by zagger on 16/9/9.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BrandFactoryViewController.h"
#import "QQWRefreshHeader.h"
#import "QQWRefreshFooter.h"
#import "BrandFactoryListApi.h"
#import "BrandFactoryCollectionViewAgent.h"

@interface BrandFactoryViewController ()<ApiRequestDelegate>

@property (nonatomic, strong) BrandFactoryListApi *listApi;

@property (nonatomic, strong) BrandFactoryCollectionViewAgent *agent;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BrandFactoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.agent.collectionView];
    [self.agent.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    weakify(self)
    self.agent.collectionView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        strongify(self)
        [self.listApi refresh];
    }];
    
    self.agent.collectionView.mj_footer = [QQWRefreshFooter footerWithRefreshingBlock:^{
        strongify(self)
        [self.listApi loadNextPage];
    }];
    
    [self.agent.collectionView.mj_header beginRefreshing];
    
}


#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
   
    [self.agent.collectionView.mj_header endRefreshing];
    [self.agent.collectionView.mj_footer resetNoMoreData];
    [[EmptyManager sharedManager] removeEmptyFromView:self.agent.collectionView];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:responsObject];
    [self.agent refreshWithDataArray:self.dataArray];
        
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
    [self.agent refreshWithDataArray:self.dataArray];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.agent.collectionView.mj_footer endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    [self.agent.collectionView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark -
- (void)setShouldScrollToTop:(BOOL)scrollToTop {
    self.agent.collectionView.scrollsToTop = scrollToTop;
}

#pragma mark - Properties
- (BrandFactoryListApi *)listApi {
    if (!_listApi) {
        _listApi = [[BrandFactoryListApi alloc] init];
        _listApi.delegate = self;
    }
    return _listApi;
}

- (BrandFactoryCollectionViewAgent *)agent {
    if (!_agent) {
        _agent = [[BrandFactoryCollectionViewAgent alloc] initWithParentViewController:self];
    }
    return _agent;
}

@end
