//
//  SystemInfoViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/14.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "SystemInfoViewController.h"
#import "SystemInfoTableViewCell.h"
#import "SystemInfoModel.h"
#import "SystemInfoApi.h"
#import "DeleSystemInfoApi.h"
#import "systemMessageDetailViewController.h"
@interface SystemInfoViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)SystemInfoApi *systemInfo;
@property (nonatomic,strong)DeleSystemInfoApi *delMessage;
@property (nonatomic,strong)NSMutableArray *systemInfoModelArr;

@end

@implementation SystemInfoViewController


static NSString* cellId = @"cellid";

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];

}



- (NSArray *)systemInfoModelArr
{

    if (!_systemInfoModelArr) {
        
        _systemInfoModelArr = [NSMutableArray array];
        
    }
    return _systemInfoModelArr;

}


- (DeleSystemInfoApi *)delMessage
{

    if (!_delMessage) {
        
        _delMessage = [[DeleSystemInfoApi alloc]init];
        
        _delMessage.delegate = self;
    }
    return _delMessage;
    
}


- (SystemInfoApi *)systemInfo
{

    if (!_systemInfo) {
        
        _systemInfo = [[SystemInfoApi alloc]init];
        
        _systemInfo.delegate = self;
    }

    return _systemInfo;
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView = [[UITableView alloc]init];
    
    [self.view addSubview:_tableView];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerClass:[SystemInfoTableViewCell class] forCellReuseIdentifier:cellId];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
    
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.systemInfo refresh];
        
    }];
    
    self.tableView.mj_footer = [QQWRefreshFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.systemInfo loadNextPage];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
}




- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    
    
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableView];
    
    if (api == _systemInfo) {
        NSArray *array = (NSArray *)responsObject;
        
        if (array.count <= 0) {
            
            [[EmptyManager sharedManager] showEmptyOnView:self.tableView withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"暂时没有消息哦" operationText:@"" operationBlock:^{
                
                systemMessageDetailViewController *detail = [systemMessageDetailViewController new];
                
                [self.navigationController pushViewController:detail animated:YES];
                
            }];
            
        } else {
            
            [self.systemInfoModelArr removeAllObjects];
            [self.systemInfoModelArr addObjectsFromArray:responsObject];
            [self.tableView reloadData];
            
        }
        
    }
    
    if (api == _delMessage) {
        
            [Utils removeHudFromView:self.view];
            
            [Utils postMessage:command.response.msg onView:self.view];
        
    }
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    
    [Utils postMessage:command.response.msg onView:self.view];
    [self.tableView.mj_header endRefreshing];
    
    if (self.systemInfoModelArr.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.tableView response:command.response operationBlock:^{
            strongify(self)
            [self.tableView.mj_header beginRefreshing];
        }];
    }
    
    if (api == _delMessage) {
        
        [Utils removeHudFromView:self.view];
        
        [Utils postMessage:command.response.msg onView:self.view];
        
    }
    
}


- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [self.tableView.mj_footer endRefreshing];
    
    [self.systemInfoModelArr addObjectsFromArray:responsObject];
    [self.tableView reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableView.mj_footer endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return  self.systemInfoModelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SystemInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    SystemInfoModel *model = [_systemInfoModelArr objectAtIndex:indexPath.row];
    if ([model.is_read isEqualToString:@"1"]) {
        cell.img.hidden = YES;
    }
    cell.content.text = model.content;
    cell.time.text = model.dateline;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if ([model.newnum integerValue] >= 0) {
//        
//        cell.img.backgroundColor = HexColor(0xd63d3e);
//        
//    }else
//    {
//        cell.img.backgroundColor = [UIColor clearColor];
//    
//    }
    
    return  cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    systemMessageDetailViewController *infoDetail = [systemMessageDetailViewController new];
    
    SystemInfoModel *model = [_systemInfoModelArr objectAtIndex:indexPath.row];
    
    infoDetail.dateline = model.dateline;
    infoDetail.content = model.content;

    [self.navigationController pushViewController:infoDetail animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    // VC编辑按钮的点击方法, 会在edit和done之间切换
    [_tableView setEditing:editing animated:animated];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        
        SystemInfoModel *model =  [self.systemInfoModelArr objectAtIndex:indexPath.row];
        
        [Utils addHudOnView:self.view];
        
        [self.delMessage deleCollectWithID:model.id];
        
        [self.systemInfoModelArr removeObjectAtIndex:indexPath.row];
        //移除数据源的数据
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
