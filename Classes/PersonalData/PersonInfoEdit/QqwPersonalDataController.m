//
//  QqwPersonalDataController.m
//  Qqw
//
//  Created by elink on 16/7/26.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "QqwPersonalDataController.h"
#import "QqwPersonalDataCell.h"
#import "QqwPersonalDataEditController.h"
#import "QqwPersonalDataHeaderView.h"
#import "QqwProvinceModel.h"
@interface QqwPersonalDataController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray* dataArr;
@property(nonatomic,strong)NSArray* titleArr;
@end

@implementation QqwPersonalDataController
{
    UITableView* personalDataTable;
}
static NSString* CellID = @"QqwPersonalDataTableCell";

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [personalDataTable reloadData];
    [self initView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initView{

    self.titleArr = @[@"个人资料",@"手机",@"昵称",@"性别",@"省份",@"市",@"区/县"];
    // 判断是否为第一次使用此APP
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/firstBoot.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    BOOL notFirstUse = YES;
    notFirstUse = [dic[@"notFirstUse"] boolValue];
   
    personalDataTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    personalDataTable.dataSource = self;
    personalDataTable.delegate = self;
    personalDataTable.bounces = YES;
    [personalDataTable registerClass:[QqwPersonalDataCell class] forCellReuseIdentifier:CellID];
    [self.view addSubview:personalDataTable];
    [personalDataTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(self.view.mas_height);
    }];
    
    
    personalDataTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,personalDataTable.size.width,150.0f)];
    QqwPersonalDataHeaderView* headerView = [[QqwPersonalDataHeaderView alloc] init];
    headerView.backgroundColor = [UIColor blackColor];
    [personalDataTable.tableHeaderView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(0.0f);
        make.left.mas_equalTo(0.0f);
        make.height.with.width.mas_equalTo(personalDataTable.tableHeaderView);
    }];
    
    [headerView setAccount:@"哇哇9956" withAccountImage:@""];
    
    
}

#pragma mark - TableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QqwPersonalDataCell* cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row==0) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell setTitle:self.titleArr[indexPath.row] withContent:self.dataArr[indexPath.row]];
    
    return cell;
}

#pragma mark - TableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
        QqwPersonalDataEditController* pdevc = [[QqwPersonalDataEditController alloc] init];
        [self.navigationController pushViewController:pdevc animated:YES];
    }
}

-(void)dealloc{
    NSLog(@"%@销毁了",NSStringFromClass([self class]));
}
@end
