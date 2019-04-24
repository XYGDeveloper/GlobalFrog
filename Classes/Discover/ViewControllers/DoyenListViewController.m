//
//  DoyenListViewController.m
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "DoyenListViewController.h"
#import "DoyenListApi.h"
#import "QQWRefreshHeader.h"
#import "DoyenCollectionViewAgent.h"
#import "DoyenListItem.h"
@interface DoyenListViewController ()<ApiRequestDelegate>

@property (nonatomic, strong) DoyenListApi *listApi;

@property (nonatomic, strong) DoyenCollectionViewAgent *agent;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DoyenListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChange) name:kLoginSuccessNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChange) name:kLogoutSuccessNotify object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChange) name:KNOTIFY_FIND_REFRESH object:nil];
    
    __weak typeof(self) wself = self;
    self.agent.collectionView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.listApi getDiscoverTopicList];
    }];
    
    [self.view addSubview:self.agent.collectionView];
    [self.agent.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    [Utils addHudOnView:self.view];
    [self.listApi getDiscoverTopicList];
}

#pragma mark ================== noty =================
-(void)loginChange{
    [self.agent.collectionView.mj_header beginRefreshing];
}

#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [Utils removeHudFromView:self.view];
    [self.agent.collectionView.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.agent.collectionView];
    self.dataArray = responsObject;

    [self.agent reloadWithItems:self.dataArray];
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils removeHudFromView:self.view];
    [self.agent.collectionView.mj_header endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
    
    if (self.dataArray.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.agent.collectionView response:command.response operationBlock:^{
            strongify(self)
            [Utils addHudOnView:self.view];
            [self.listApi getDiscoverTopicList];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
}



#pragma mark - Properties
- (DoyenListApi *)listApi {
    if (!_listApi) {
        _listApi = [[DoyenListApi alloc] init];
        _listApi.delegate = self;
    }
    return _listApi;
}

- (DoyenCollectionViewAgent *)agent {
    if (!_agent) {
        _agent = [[DoyenCollectionViewAgent alloc] initWithParentViewController:self];
    }
    return _agent;
}

@end
