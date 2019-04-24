//
//  AddressViewController.m
//  Qqw
//
//  Created by XYG on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "AddressViewController.h"
#import "DefaultTableViewCell.h"
#import "NomalTableViewCell.h"
#import "AddressModel.h"
#import <MJRefresh.h>
#import "User.h"
#import "LoginViewControll.h"
#import "QQWRefreshHeader.h"
#import "AddAddressViewController.h"
@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *addressTableView;
@property (nonatomic,strong)UIButton *addAddress;
@property (nonatomic,strong)NSMutableArray *addressArray;
@property (nonatomic,strong)NSArray *modelArr;
@property (nonatomic,strong)UIImageView *topImg;
@property (nonatomic,strong)UIButton *selectAddress;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)User *_userInfo;


@end

@implementation AddressViewController

static NSString* defaultCell = @"Default";
static NSString* NormalCell = @"Normal";


-(void) initWithView
{
    
    _topImg = [[UIImageView alloc]init];
    [self.view addSubview:_topImg];
    _topImg.image = [UIImage imageNamed:@"address_top"];
    [_topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(7);
    }];
    _addressTableView = [[UITableView alloc]init];
    _addressTableView.dataSource = self;
    _addressTableView.delegate = self;
    _addressTableView.backgroundColor = DefaultBackgroundColor;
    _addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _addressTableView.tableFooterView = [[UIView alloc] init];
    [_addressTableView registerClass:[DefaultTableViewCell class] forCellReuseIdentifier:defaultCell];
    [_addressTableView registerClass:[NomalTableViewCell class] forCellReuseIdentifier:NormalCell];
    [self.view addSubview:_addressTableView];
    [_addressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_topImg.mas_bottom).mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
        
    }];
    


    
    _addressTableView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        _page = 1;
        
        [self updateData];
    }];
    
    
    _addressTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self updateData];
    }];
    
    
    _addAddress = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_addAddress];
    _addAddress.backgroundColor = [UIColor colorWithRed:0.298 green:0.663 blue:0.149 alpha:1.000];
    [_addAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(0);
        
    }];
    [_addAddress setTitle:@"添加新地址" forState:UIControlStateNormal];
    [_addAddress setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addAddress.titleLabel.font =[UIFont systemFontOfSize:14.0f];
    [_addAddress addTarget:self action:@selector(addAddressAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void) updateView{
    [self.addressTableView reloadData];
}

-(void)endRefresh{
    [self.addressTableView.mj_header endRefreshing];
    [self.addressTableView.mj_footer endRefreshing];
}

- (void)updateData{
    [AddressModel requestAddressListWithPage:_page dataArray:_addressArray superView:nil finshBlock:^(id obj, NSError *error) {
        [self endRefresh];
        if (self.addressArray.count <= 0) {
            
            [[EmptyManager sharedManager] showEmptyOnView:self.view
                                                withImage:[UIImage imageNamed:@"personal_address_empty"]
                                                  explain:@"暂无收货地址"
                                            operationText:@"新添加地址"
                                           operationBlock:^{
                                               [self pushEidAddresViewCtrWithType:(FreshAddressType_Add) model:nil];
                                           }];
        } else {
            [self.addressTableView reloadData];
        }

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _addressArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressModel *model = [_addressArray objectAtIndex:indexPath.row];
    DefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    cell.model = model;
 
    weakify(cell)
    cell.btnAction = ^(AddressModel *model){
        strongify(cell)
        cell.faultAddress.selected = !cell.faultAddress.selected;
        if (model.is_default == YES) {
            model.is_default = 0;
        }else{
            model.is_default = 1;
        }
        NSLog(@"%@",model.mj_JSONString);
        [AddressModel requestUpdateAddressInfoWithAddress:model type:3 superView:self.navigationController.view finshBlock:^(id obj, NSError *error) {
            for (AddressModel * addres in _addressArray) {
                if (model.is_default == 1&&model != addres) {
                    addres.is_default = 0;
                }
            }
            [self.addressTableView reloadData];
        }];
    };
    
    cell.telephone.text = model.mobile;
    cell.address.text = model.fullAddress;//[NSString stringWithFormat:@"%@ %@ %@ %@ %@",model.province,model.city,model.district,model.area,model.details];
    cell.nikeName.text = model.name;
    
    cell.editBlock = ^(){
        [self pushEidAddresViewCtrWithType:(FreshAddressType_update) model:model];

    };
    
    return cell;
}


- (void)editAction:(UIButton *)btn{

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [_addressTableView setEditing:editing animated:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        
       AddressModel *model =  [self.addressArray objectAtIndex:indexPath.row];

        [AddressModel requestUpdateAddressInfoWithAddress:model type:1 superView:self.view finshBlock:^(id obj, NSError *error) {
            
        }];
    }
    [self.addressArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressModel *model = [_addressArray objectAtIndex:indexPath.row];
 
    if (self.selectblock) {
        self.selectblock(model);
    }
    if (self.flage == YES) {
        return;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}

- (void)addAddressAction:(UIButton *)add{
    [self pushEidAddresViewCtrWithType:(FreshAddressType_Add) model:nil];
}


-(void)pushEidAddresViewCtrWithType:(FreshAddressType)typ model:(AddressModel *) model{
    AddAddressViewController * addVct  = [[AddAddressViewController alloc]initWithStyle:(UITableViewStyleGrouped)];
    addVct.freshAddressType = typ;
    addVct.addressInfo = model;
    [self.navigationController pushViewController:addVct animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _addressArray = [NSMutableArray new];
    [self initWithView];
    self.title = @"我的地址";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.addressTableView.mj_header beginRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
