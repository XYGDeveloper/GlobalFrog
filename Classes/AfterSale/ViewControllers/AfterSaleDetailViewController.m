//
//  AfterSaleDetailViewController.m
//  Qqw
//
//  Created by zagger on 16/9/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "AfterSaleDetailViewController.h"
#import "AfterSaleDetailCell.h"
#import "QQWRefreshHeader.h"
#import "OrderModel.h"
#import "AfterSaleDetailApi.h"

@interface AfterSaleDetailViewController ()<ApiRequestDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AfterSaleDetailApi *detailApi;

@property (nonatomic, strong) AfterSaleModel *dataModel;

@end

@implementation AfterSaleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"售后详情";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    weakify(self)
    self.tableView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        strongify(self)
        [self.detailApi getAfterSaleDetailWithIdentifier:self.afterSaleGoods.return_sn];
    }];
    
    [Utils addHudOnView:self.view];
    [self.detailApi getAfterSaleDetailWithIdentifier:self.afterSaleGoods.return_sn];
}


#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [Utils removeHudFromView:self.view];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableView];
    
    self.dataModel = responsObject;
    self.tableView.tableHeaderView = [self headerView];
    self.tableView.tableFooterView = [self footerView];
    [self.tableView reloadData];
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
    
    weakify(self)
    [[EmptyManager sharedManager] showNetErrorOnView:self.tableView response:command.response operationBlock:^{
        strongify(self)
        [Utils addHudOnView:self.view];
        [self.detailApi getAfterSaleDetailWithIdentifier:self.afterSaleGoods.return_sn];
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AfterSaleDetailCell *cell = (AfterSaleDetailCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AfterSaleDetailCell class])];
    
    AfterSaleDetailList *model = [self.dataModel.list safeObjectAtIndex:indexPath.row];
    [cell refreshWithModel:model isTop:indexPath.row == 0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods
- (UIView *)headerView {
    if (self.dataModel) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 33.0)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UILabel *orderLabel = GeneralLabel(Font(11), TextColor1);
        orderLabel.text = [NSString stringWithFormat:@"订单编号:%@",self.dataModel.detail.order_sn];
        
        UILabel *afterSaleLabel = GeneralLabelA(Font(11), TextColor1, NSTextAlignmentRight);
        afterSaleLabel.text = [NSString stringWithFormat:@"退单编号:%@",self.dataModel.detail.return_sn];
        
        [headView addSubview:orderLabel];
        [headView addSubview:afterSaleLabel];
        
        [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@5);
            make.centerY.equalTo(headView);
        }];
        
        [afterSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-5);
            make.centerY.equalTo(headView);
        }];
        
        return headView;
    }
    return nil;
}

- (UIView *)footerView {
    if (self.dataModel) {
//        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 62)];
//        footView.backgroundColor = [UIColor whiteColor];
        
        UILabel *fixLabel = GeneralLabel(Font(12), TextColor2);
        fixLabel.text = @"备注：";
        
        UILabel *contentLabel = GeneralLabel(Font(12), TextColor2);
        contentLabel.numberOfLines = 0;
        
        NSString *str = [NSString stringWithFormat:@"选择售后服务类型为%@",self.dataModel.detail.return_txt];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        [attrString addAttribute:NSFontAttributeName value:BFont(12) range:[str rangeOfString:self.dataModel.detail.return_type]];
        
        if (self.dataModel.detail.reason.length > 0) {
            str = [NSString stringWithFormat:@"%@\n申请售后理由为%@",str,self.dataModel.detail.reason];
            [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            attrString = [[NSMutableAttributedString alloc] initWithString:str];
            [attrString addAttribute:NSFontAttributeName value:BFont(12) range:[str rangeOfString:self.dataModel.detail.return_type]];
            [attrString addAttribute:NSFontAttributeName value:BFont(12) range:[str rangeOfString:self.dataModel.detail.reason]];
        }
        
        contentLabel.attributedText = attrString;
        //自适应label行高
        CGSize textSize = [attrString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        CGFloat wordWidth = textSize.width / attrString.length;
        int wordCount = (self.view.bounds.size.width - 15) / wordWidth;
        CGFloat heightCount= attrString.length / wordCount;
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height * heightCount+30)];
        footView.backgroundColor = [UIColor whiteColor];
        [footView addSubview:fixLabel];
        [footView addSubview:contentLabel];
        
        [fixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(contentLabel);
        }];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fixLabel.mas_right);
            make.right.lessThanOrEqualTo(@-20);
            make.centerY.equalTo(footView);
        }];
        
        return footView;
    }
    return [[UIView alloc] init];
}


#pragma mark - Properties
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 45, 0, 0);
        [_tableView registerClass:[AfterSaleDetailCell class] forCellReuseIdentifier:NSStringFromClass([AfterSaleDetailCell class])];
    }
    return _tableView;
}

- (AfterSaleDetailApi *)detailApi {
    if (!_detailApi) {
        _detailApi = [[AfterSaleDetailApi alloc] init];
        _detailApi.delegate = self;
    }
    return _detailApi;
}

@end
