//
//  SearchAddressView.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/17.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "SearchAddressView.h"
#import "SearchAddressTableViewCell.h"


@implementation SearchAddressView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, kScreenHeight/2-64, kScreenWidth, kScreenHeight/2);

        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        backView.backgroundColor = [UIColor whiteColor];

        [self addSubview:backView];
        
        MySegmentView * sg = [[MySegmentView alloc]initWithFrame:CGRectMake(0, 0, self.width, 45) Array:@[@"全部",@"写字楼",@"小区",@"学校"]];
        sg.delegate = self;
        [backView addSubview:sg];
        
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, sg.height, self.width, self.height-sg.height)];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.separatorStyle = NO;
         [_tabelView registerNib:[UINib nibWithNibName:@"SearchAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        [backView addSubview:_tabelView];
        
    }
    return self;
}
#pragma mark ================== Table view data source =================
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.mapPoi = _dataArray[indexPath.row];


    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapPOI *mapPoi = _dataArray[indexPath.row];
    
    if (_selectMapPoiBlock) {
        _selectMapPoiBlock(mapPoi);
    }
//    [Utils popBackFreshWithObj:mapPoi view:self];

}
#pragma mark ================== mysgement delegate =================
-(void)callBackSelectSegment:(MySegmentView *)segment but:(UIButton *)sender{
    NSString * s = sender.titleLabel.text;
    if ([sender.titleLabel.text isEqualToString:@"全部"]) {
        s = @"";
    }
    _selectBlcok(s);
}

#pragma mark ================== wode =================
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.tabelView reloadData];
    if (dataArray.count != 0) {
        [self.tabelView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
-(void)show{
    [[AppDelegate APP].window addSubview:self];
}


@end
