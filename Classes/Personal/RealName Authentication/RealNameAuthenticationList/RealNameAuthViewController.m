//
//  RealNameAuthViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2017/1/5.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "RealNameAuthViewController.h"
#import "RealNameAuthenticationViewController.h"
#import "RealListModel.h"
#import "EmptyManager.h"
#import "AuthTableViewCell.h"
@interface RealNameAuthViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *realNameAuthList;

@property (nonatomic,strong)NSMutableArray *realNameListArray;

@property (nonatomic,strong)UIButton *addRealNameAuthButton;


@end

@implementation RealNameAuthViewController

static  NSString *const realIdentityCellIeentity = @"realIdentityCellIeentity";


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.realNameAuthList.mj_header beginRefreshing];
}

- (UIButton *)addRealNameAuthButton{
    if (!_addRealNameAuthButton) {
        _addRealNameAuthButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _addRealNameAuthButton.layer.borderWidth = 1;
        _addRealNameAuthButton.layer.cornerRadius = 2;
        _addRealNameAuthButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _addRealNameAuthButton.layer.borderColor = AppStyleColor.CGColor;
        [_addRealNameAuthButton setTitle:@"添加实名信息" forState:UIControlStateNormal];
        [_addRealNameAuthButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
    }

    return _addRealNameAuthButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _realNameListArray = [NSMutableArray array];

    self.view.backgroundColor = DefaultBackgroundColor;
    [self setRightNavigationItemWithTitle:@"添加" action:@selector(addRealNameInfo)];
    [self.addRealNameAuthButton addTarget:self action:@selector(addRealNameInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addRealNameAuthButton];
    self.realNameAuthList = [[UITableView alloc]init];
    self.realNameAuthList.backgroundColor = DefaultBackgroundColor;
    [self.view addSubview:_realNameAuthList];
    self.realNameAuthList.delegate = self;
    self.realNameAuthList.dataSource = self;
    self.realNameAuthList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.realNameAuthList registerNib:[UINib nibWithNibName:@"AuthTableViewCell" bundle:nil] forCellReuseIdentifier:realIdentityCellIeentity];
    [self.realNameAuthList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-45);
    }];
    
    [self.addRealNameAuthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.realNameAuthList.mas_bottom).mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    
    __weak typeof(self) wself = self;
    self.realNameAuthList.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself request];
    }];
    
}

#pragma mark ================== wode =================
-(void)request{
    [RealListModel requestRealListWithSuperView:nil finshBlock:^(id obj, NSError *error) {
        [self.realNameAuthList.mj_header endRefreshing];
        [[EmptyManager sharedManager] removeEmptyFromView:self.realNameAuthList];
        NSArray *array = (NSArray *)obj;
        if (array.count <= 0) {
            [[EmptyManager sharedManager] showEmptyOnView:self.realNameAuthList withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"暂时没有添加任何认证信息哦" operationText:nil operationBlock:nil];
        } else {
            self.realNameListArray = obj;
            [self.realNameAuthList reloadData];
        }
    }];
}

- (void)addRealNameInfo{
    RealNameAuthenticationViewController *Authen = [[RealNameAuthenticationViewController alloc]init];
    Authen.hidesBottomBarWhenPushed = YES;
    Authen.title = @"实名认证";
    [self.navigationController pushViewController:Authen animated:YES];
}

-(void)changeRequestWitchModel:(RealListModel *)realListModel type:(int)type index:(NSIndexPath*)indexPath{
    [RealListModel requestEditRealWithId:realListModel.rID type:type superView:self.view finshBlock:^(id obj, NSError *error) {
        if (!error) {
            if (type == 0) {
                for ( RealListModel *m in self.realNameListArray) {
                    m.is_default = @"0";
                }
                realListModel.is_default = @"1";
               

            }else{
                
                [self.realNameListArray removeObject:realListModel];
//                [self.realNameAuthList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
                if (self.realNameListArray.count <= 0) {
                    [[EmptyManager sharedManager] showEmptyOnView:self.realNameAuthList withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"暂时没有添加任何认证信息哦" operationText:nil operationBlock:nil];
                }
            }
            [self.realNameAuthList reloadData];
        }
    }];
}
#pragma mark ================== tabelView delegate =================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.realNameListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AuthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:realIdentityCellIeentity];
    cell.realListModel = [self.realNameListArray objectAtIndex:indexPath.row];
    weakify(cell);
    cell.setDefaultRealName = ^(){
         strongify(cell);
        [self changeRequestWitchModel:cell.realListModel type:0 index:indexPath];
    };
    
    cell.toDelete = ^(){
        strongify(cell);
        [self changeRequestWitchModel:cell.realListModel type:1 index:indexPath];
    };

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        RealListModel *model =  [self.realNameListArray objectAtIndex:indexPath.row];
        [self changeRequestWitchModel:model type:1 index:indexPath];

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RealListModel *model = [self.realNameListArray objectAtIndex:indexPath.row];

    if (self.selectblock) {
        self.selectblock(model);
    }
   
    if (self.flage == YES) {
        return;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
