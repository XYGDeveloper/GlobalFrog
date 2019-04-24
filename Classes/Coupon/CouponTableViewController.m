//
//  CouponTableViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/15.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "CouponTableViewController.h"
#import "ConponTableViewCell.h"

@interface CouponTableViewController ()

@end

static NSString * idCell = @"idCell";
@implementation CouponTableViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券";
    [self.tableView registerClass:[ConponTableViewCell class] forCellReuseIdentifier:idCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!_selectUseConpon) {
        self.tableView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
            [self request];
        }];
        [self.tableView.mj_header beginRefreshing];
    }

}

-(void)request{
    [ConponModel requestConponWithDataArray:self.dataArray type:_conponType page:1 superView:nil finshBlock:^(id obj, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (_dataArray.count <= 0) {
            [[EmptyManager sharedManager] showEmptyOnView:self.view
                                                withImage:[UIImage imageNamed:@"person_collect_chant"]
                                                  explain:@"列表是空的"
                                            operationText:@""
                                           operationBlock:nil];
        }else {
            [[EmptyManager sharedManager] removeEmptyFromView:self.view];
            [self.tableView reloadData];
        }
        
    }];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    cell.selectionStyle = NO;
    [cell setDataWithType:_conponType conponModel:self.dataArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectUseConpon) {
        ConponModel *model = [self.dataArray objectAtIndex:indexPath.row];
        _selectUseConpon(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ================== super =================
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
