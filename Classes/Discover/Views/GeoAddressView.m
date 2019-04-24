//
//  GeoAddressView.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/18.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "GeoAddressView.h"


@implementation GeoAddressView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
        
        _tabelView = [UITableView new];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        [self addSubview:_tabelView];
        [_tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(@0);
        }];
        
    }
    return self;
}

#pragma mark ================== Table view data source =================
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * celliden = @"seachCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celliden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:celliden];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    AMapPOI *mapPoi = _dataArray[indexPath.row];
    cell.textLabel.text = mapPoi.name;
    cell.detailTextLabel.text = mapPoi.address;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapPOI *mapPoi = _dataArray[indexPath.row];
    
    if (_selectMapPoiBlock) {
        _selectMapPoiBlock(mapPoi);
    }else{
        [Utils popBackFreshWithObj:mapPoi view:self];
    }
}

#pragma mark ================== wode  =================
-(void)showWithData:(NSMutableArray *)data{
    self.hidden = NO;
    _dataArray = data;
    [_tabelView reloadData];
}

-(void)showWithView:(UIView *)view data:(NSMutableArray *)data{
    self.hidden = NO;
    [view addSubview:self];
    if (data) {
        _dataArray = data;
        [_tabelView reloadData];
    }
}

-(void)dismiss{
    self.hidden = YES;
    [self removeFromSuperview];
}




@end
