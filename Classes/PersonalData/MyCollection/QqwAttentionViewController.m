//
//  QqwAttentionViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/7.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "QqwAttentionViewController.h"
#import "AttentionTableViewCell.h"
@interface QqwAttentionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *attentionTableView;

@end

@implementation QqwAttentionViewController


- (void)setUI
{

    self.attentionTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_attentionTableView];
    [self.attentionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.attentionTableView registerClass:[AttentionTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.attentionTableView.delegate = self;
    self.attentionTableView.dataSource = self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return  10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 120;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    AttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.attentionButton.tag = 100 + indexPath.row;
    
    weakify(cell);
    cell.addAttention = ^(AttentionModel *model){
        strongify(cell);
        
        cell.attentionButton.selected = !cell.attentionButton.selected;
        
        if (cell.attentionButton.selected) {
            cell.attentionButton.layer.borderColor = HexColor(0xd6d7dc).CGColor;
            [cell.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
            [cell.attentionButton setTitleColor:HexColor(0xd6d7dc) forState:UIControlStateNormal];
        }else
        {
            [cell.attentionButton setTitle:@"+ 关注" forState:UIControlStateNormal];
            cell.attentionButton.layer.borderColor = HexColor(0x5cb531).CGColor;
            [cell.attentionButton setTitleColor:HexColor(0x5cb531) forState:UIControlStateNormal];
            
        }
        
        //cell的重用问题，用接口返回的布尔值来做判断；
        
        
    };
    
    return cell;

}

@end
