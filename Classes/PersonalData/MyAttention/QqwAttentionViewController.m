//
//  QqwAttentionViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/7.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "QqwAttentionViewController.h"
#import "AttentionTableViewCell.h"

#import "AttentionModel.h"
#import "DoyenArticleListViewController.h"
#import "DoyenListItem.h"
@interface QqwAttentionViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int _page;
    
}

@property (nonatomic,strong)UITableView *attentionTableView;
@property (nonatomic,strong)NSMutableArray *attentionModelArr;

@property (nonatomic,assign)BOOL isAttention;

@end

@implementation QqwAttentionViewController

static NSString *const attentionTableviewCellIdentity = @"attentionTableviewCellIdentity";
- (void)setUI{

    self.attentionTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_attentionTableView];
    [self.attentionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.attentionTableView registerClass:[AttentionTableViewCell class] forCellReuseIdentifier:attentionTableviewCellIdentity];
    self.attentionTableView.delegate = self;
    self.attentionTableView.dataSource = self;
    self.attentionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) wself = self;
    self.attentionTableView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        _page = 1;
        [sself request];
        
    }];
    
    self.attentionTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        _page++;
        [sself request];
    }];
    
    [self.attentionTableView.mj_header beginRefreshing];
    
}

-(void)request{
    [AttentionModel requestAttentuonListWithDataArray:_attentionModelArr page:_page superView:nil finshBlock:^(id obj, NSError *error) {
        [self.attentionTableView.mj_header endRefreshing];
        [self.attentionTableView.mj_footer endRefreshing];
        [self nodata];
        [self.attentionTableView reloadData];
    }];
}

-(void)nodata{
    if (_attentionModelArr.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.attentionTableView withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"暂时没有关注任何人哦" operationText:@"" operationBlock:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _attentionModelArr = [NSMutableArray new];
    [self setUI];
    self.title = @"关注";
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return  self.attentionModelArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    AttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attentionTableviewCellIdentity];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AttentionModel *model = [_attentionModelArr objectAtIndex:indexPath.row];
    cell.model = model;
    
    cell.attentionButton.selected = YES;
    cell.attentionButton.layer.borderColor = HexColor(0xd6d7dc).CGColor;
    [cell.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
    [cell.attentionButton setTitleColor:HexColor(0xd6d7dc) forState:UIControlStateNormal];
//    weakify(cell);
    cell.addAttention = ^(AttentionModel *model){
//        strongify(cell);
        NSLog(@"%@",model.uid);
            [AttentionModel requestAttentuonWithFuid:model.uid type:1 superView:self.view finshBlock:^(id obj, NSError *error) {
                if (!error) {
                  
                    [_attentionModelArr removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    
                    NSString * s  = [NSString stringWithFormat:@"%@,%@,%@",model.uid,@"0",@"0"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:KNOTIFY_CHANGE_HT5_REFRESH object:s];
                      [self nodata];
                }
            }];

    };
    
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AttentionModel *model = [self.attentionModelArr objectAtIndex:indexPath.row];
    NSLog(@"%@",model.mj_keyValues);
    DoyenArticleListViewController *vc = [[DoyenArticleListViewController alloc] initWithTopicIdentifier:model.uid];
    vc.title = model.nickname;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
