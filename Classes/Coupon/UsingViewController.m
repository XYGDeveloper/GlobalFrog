//
//  UsingViewController.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "UsingViewController.h"

#import "UsingTableViewCell.h"
@interface UsingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation UsingViewController

static NSString* use = @"usingCell";

- (void)initWithController
{

    self.tableView = [[UITableView alloc]init];
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UsingTableViewCell class] forCellReuseIdentifier:use];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UsingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:use];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithController];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
