//
//  AddAddressViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/6.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "AddAddressViewController.h"
#import "NewAdressCellTableViewCell.h"
#import "QqwAddressPickerView.h"
#import "MyPickView.h"
#import "MapViewController.h"
#import "ValidatorUtil.h"
@interface AddAddressViewController ()<UITextFieldDelegate>{
    QqwAddressPickerView *picker;
    MyPickView * _myPickView;
}

@property(nonatomic,strong)NSString * loctionCityName;

@end

static NSString * idCell = @"cell";
@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_freshAddressType == FreshAddressType_Add) {
        self.title = @"新增收货地址";
    }else if (_freshAddressType == FreshAddressType_update){
        self.title = @"更新收货地址";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(clickSave)];
    self.navigationItem.rightBarButtonItem.tintColor = AppStyleColor;

    [self.tableView registerNib:[UINib nibWithNibName:@"NewAdressCellTableViewCell" bundle:nil] forCellReuseIdentifier:idCell];
    _loctionCityName = @"";
    
//    _myPickView = [MyPickView new];
//    if (_addressInfo) {
//        if ([_addressInfo.details rangeOfString:_addressInfo.area].length>0) {
//            _addressInfo.details = [_addressInfo.details substringFromIndex:_addressInfo.area.length];
//        }
//    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectMop:) name:KNotification_Select_Address_ADD object:nil];
    [self startLocation];
}
#pragma mark ================== noty =================
-(void)selectMop:(NSNotification*)noty{
    AMapPOI * a = noty.object;
    _addressInfo.area = a.name;
    _addressInfo.lat = a.location.latitude;
    _addressInfo.lng = a.location.longitude;
    [self.tableView reloadData];
}

#pragma mark ================== wode =================
-(void)clickSave{
    [self.view endEditing:YES];
    if (_addressInfo.details.length<1) {
        [Utils showErrorMsg:self.view type:0 msg:@"请输入收货人的详细地址"];
        return;
    }
    
    if (_addressInfo.name.length<1) {
         [Utils showErrorMsg:self.view type:0 msg:@"请输入收货人的姓名"];
        return;
    }
    
    NSError *error = nil;
    if (![ValidatorUtil isValidMobile:_addressInfo.mobile error:&error]) {
        [Utils showErrorMsg:self.view type:0 msg:[error localizedDescription]];
        return;
    }
    
    [AddressModel requestUpdateAddressInfoWithAddress:_addressInfo type:_freshAddressType superView:self.view finshBlock:^(id obj, NSError *error) {
        if (!error) {
            NSString * str = nil;
            if (_freshAddressType == FreshAddressType_Add) {
                str = @"添加地址成功";
            }else if (_freshAddressType == FreshAddressType_update){
                str = @"更新地址成功";
            }
            [Utils showErrorMsg:[AppDelegate APP].window type:0 msg:str];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ================== Table view data source ==================
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (_freshAddressType == FreshAddressType_update){
//        return 3;
//    }
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewAdressCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell forIndexPath:indexPath];
    cell.selectionStyle = NO;
    cell.msgTextField.userInteractionEnabled = YES;
    cell.msgTextField.delegate = self;
    cell.msgTextField.tag = 10000*(indexPath.section+1)+indexPath.row;
    cell.accessoryView.hidden = YES;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"收货地址";
            cell.msgTextField.text = _addressInfo.area;
        }else{
            cell.msgTextField.placeholder = @"";
             cell.msgTextField.placeholder = @"具体信息（如楼号／楼层／房号）";
            cell.msgTextField.text = _addressInfo.details;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"联系人";
            cell.msgTextField.text = _addressInfo.name;
            cell.msgTextField.placeholder = @"您的姓名";
        }else{
            cell.titleLabel.text = @"手机号";
            cell.msgTextField.placeholder = @"配送员联系您的手机号";
            cell.msgTextField.text = _addressInfo.mobile;
            cell.msgTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }else{
//        cell.titleLabel.text = @"标签";
        cell.msgTextField.placeholder = nil;

        cell.msgTextField.userInteractionEnabled = NO;
        cell.titleLabel.text = @"设为默认";
        cell.accessoryView.hidden = NO;
        UISwitch * s = [cell viewWithTag:3333];
        if (!s) {
            s = [UISwitch new];
            [s addTarget:self action:@selector(setDefaultAddress:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = s;
        }
        
        [s setOn:_addressInfo.is_default animated:NO];
        
    }
    
    return cell;
}

#pragma mark ================== wode =================
-(void)setDefaultAddress:(UISwitch*)s{
    _addressInfo.is_default = s.on;
}

- (void)startLocation {
    [[LocationManager sharedManager]startLocationUpdateLocation:^(CLLocation *tmpLocation) {
        _currentLocation = tmpLocation;
    } Success:^(CLPlacemark *placeMark) {
        if (!_addressInfo) {
            _addressInfo = [AddressModel new];
            _addressInfo.lat = _currentLocation.coordinate.latitude;
            _addressInfo.lng = _currentLocation.coordinate.longitude;
            _addressInfo.area = placeMark.name;
        }
        _loctionCityName = placeMark.locality;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark ================== textField delegate =================
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 10000) {
        MapViewController * ma = [MapViewController new];
        ma.loctionCityName = _loctionCityName;
        ma.isNoPushRoot = YES;
        [self.navigationController pushViewController:ma animated:YES];
        return NO;
    }else if (textField.tag == 30000) {
        //        [self.view endEditing:YES];
        ////         [_myPickView showWithData:@[@"无",@"家",@"公司"] block:^(NSString *str) {
        ////             textField.text = str;
        ////         }];
        //        return NO;
        //    }
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 10001:
            _addressInfo.details = textField.text;

            break;
        case 20000:
            _addressInfo.name = textField.text;
            break;
        case 20001:
            _addressInfo.mobile = textField.text;
            break;
        default:
            break;
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
