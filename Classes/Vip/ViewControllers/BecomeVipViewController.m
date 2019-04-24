//
//  BecomeVipViewController.m
//  Qqw
//
//  Created by zagger on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BecomeVipViewController.h"
#import "VipSexSelectCell.h"
#import "TPKeyboardAvoidingTableView.h"

#import "User.h"
#import "VipApi.h"
#import "AddressPicker.h"
#import "AgeBracketPicker.h"

#import "OrderModel.h"
#import "PayModeViewController.h"

@interface BecomeVipViewController ()<UITableViewDelegate, UITableViewDataSource, ApiRequestDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;

@property (nonatomic, strong) VipApi *getApi;
@property (nonatomic, strong) VipExplain *explain;

@property (nonatomic, strong) BecomeVipApi *becomeApi;
@property (nonatomic, strong) BecomeVipReq *becomeReq;

@property (nonatomic, strong) UILabel *fixLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) VipEditCell *phoneCell;
@property (nonatomic, strong) VipEditCell *nameCell;
@property (nonatomic, strong) VipEditCell *ageCell;
@property (nonatomic, strong) VipEditCell *addressCell;
@property (nonatomic, strong) VipSexSelectCell *sexCell;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation BecomeVipViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"成为会员";
    self.becomeReq = [[BecomeVipReq alloc] init];
    
    [self.confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    self.dataArray = @[self.phoneCell, self.nameCell, self.sexCell, self.ageCell, self.addressCell];
    for (VipEditCell *cell in self.dataArray) {
        __weak typeof(self) wself = self;
        cell.contentChangedBlock = ^{
            __strong typeof(wself) sself = wself;
            [sself isInfoCompleted];
        };
    }
    
    [Utils addHudOnView:self.view];
    [self.getApi getVipExplain];
}

- (void)popButtonClicked:(id)sender {
    weakify(self)
    UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"" message:@"您还未成为会员，确认要离开吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
        strongify(self)
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [alertView show];
}


#pragma mark - Events
- (void)confirmButtonClicked:(id)sender {
    self.becomeReq.mobile = self.phoneCell.text;
    self.becomeReq.username = self.nameCell.text;
    self.becomeReq.sex = self.sexCell.sex;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kPauseCountRobot object:nil];
    
    [Utils addHudOnView:self.view];
    [self.becomeApi becomeVipWithReq:self.becomeReq];
    
    [MobClick event:kEventOrderBecomeVip];
}

- (void)refresh {
    self.phoneCell.text = self.explain.mobile;
    if (self.explain.isFree) {//免费
        [self.confirmButton setTitle:@"免费成为会员" forState:UIControlStateNormal];
    }
    else {//收费
        [self.confirmButton setTitle:@"马上成为会员" forState:UIControlStateNormal];
    }
    
    NSString *plStr = @"[price]";
    NSRange plRange = [self.explain.content rangeOfString:plStr];
    if (plRange.location != NSNotFound) {
        NSString *priceStr = [NSString stringWithFormat:@"%@元", self.explain.price];
        NSString *str = [self.explain.content stringByReplacingCharactersInRange:plRange withString:priceStr];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attr addAttribute:NSForegroundColorAttributeName value:AppStyleColor range:[str rangeOfString:priceStr]];
        self.fixLabel.attributedText = attr;
    } else {
        self.fixLabel.text = self.explain.content;
    }
    
    self.tableView.tableHeaderView = [self headerView];
    self.tableView.tableFooterView = [self footerView];
    [self.tableView reloadData];
}


#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [Utils removeHudFromView:self.view];
    if (api == self.getApi) {
        self.explain = responsObject;
        [self refresh];
    }
    else if (api == self.becomeApi) {
        if (self.explain.isFree) {
            
            [User LocalUser].ismember = YES;
            [User LocalUser].role = kUserRoleVip;
            //设置需要刷新用户信息，在下次进入个人中心时进行刷新
            [User LocalUser].shouldRefreshUserInfo = YES;
            
            [Utils postMessage:command.response.msg onView:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            OrderModel *order = [[OrderModel alloc] init];
            order.order_sn = responsObject[@"order_sn"];
            order.order_amount = responsObject[@"price"];
            
            PayModeViewController *vc = [[PayModeViewController alloc] initWithOrder:order];
            
            NSInteger count = self.navigationController.viewControllers.count;
            vc.shouldJumpToSuccessPage = NO;
            vc.paySuccessJumpViewController = [self.navigationController.viewControllers safeObjectAtIndex:count - 2];
            
            //支付成功后，修改用户会员状态
            weakify(self)
            vc.paySuccessCallBack = ^{
                strongify(self)
                
                [User LocalUser].ismember = YES;
                [User LocalUser].role = kUserRoleVip;
                //设置需要刷新用户信息，在下次进入个人中心时进行刷新
                [User LocalUser].shouldRefreshUserInfo = YES;
                
                StewardSelectViewController *vc = [[StewardSelectViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
    
    if (api == self.getApi) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.view response:command.response operationBlock:^{
            strongify(self)
            [Utils addHudOnView:self.view];
            [self.getApi getVipExplain];
        }];
    } else if (api == self.becomeApi) {
        
    }
}



#pragma mark - Private Methods
- (BOOL)isInfoCompleted {
    if (self.phoneCell.text.length > 0 &&
        self.nameCell.text.length > 0 &&
        self.ageCell.text.length > 0 &&
        self.addressCell.text.length > 0 &&
        self.sexCell.sex.length > 0) {
        
        self.confirmButton.enabled = YES;
        
        return YES;
    }
    
    self.confirmButton.enabled = NO;
    return NO;
}

- (UIView *)headerView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 120.0)];
    headView.backgroundColor = RGB(249, 249, 249);
    
    [headView addSubview:self.fixLabel];
    [self.fixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-10);
        make.centerY.equalTo(headView);
    }];
    
    return headView;
}

- (UIView *)footerView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 144.0)];
    self.confirmButton.frame = CGRectMake(10.0, 50.0, self.view.width - 20.0, 44.0);
    [footView addSubview:self.confirmButton];
    
    return footView;
}



#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataArray safeObjectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak typeof(self) wself = self;
    if (indexPath.row == 3) {//选择年龄
        [AgeBracketPicker showOnView:self.view withSelectBlock:^(NSString *ageBracket) {
            __strong typeof(wself) sself = wself;
            sself.ageCell.text = ageBracket;
            sself.becomeReq.years = ageBracket;
        }];
    } else if (indexPath.row == 4) {//选择地区
        [AddressPicker showOnView:self.view withSelectBlock:^(AddressModel *address) {
            __strong typeof(wself) sself = wself;
            sself.addressCell.text = address.areaDisplayString;
            sself.becomeReq.province = address.province;
            sself.becomeReq.city = address.city;
            sself.becomeReq.district = address.district;
        }];
    }
}



#pragma mark - Properties
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (VipApi *)getApi {
    if (!_getApi) {
        _getApi = [[VipApi alloc] init];
        _getApi.delegate = self;
    }
    return _getApi;
}

- (BecomeVipApi *)becomeApi {
    if (!_becomeApi) {
        _becomeApi = [[BecomeVipApi alloc] init];
        _becomeApi.delegate = self;
    }
    return _becomeApi;
}

- (UILabel *)fixLabel {
    if (!_fixLabel) {
        _fixLabel = GeneralLabelA(Font(14), HexColor(0x323232), NSTextAlignmentCenter);
        _fixLabel.numberOfLines = 0;
    }
    return _fixLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _confirmButton.enabled = NO;
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
        
        _confirmButton.titleLabel.font = Font(14);
        [_confirmButton setTitleColor:HexColor(0xffffff) forState:UIControlStateNormal];
        [_confirmButton setTitleColor:HexColorA(0xffffff, 0.4) forState:UIControlStateDisabled];
        [_confirmButton setBackgroundImage:[UIImage imageWithColor:AppStyleColor] forState:UIControlStateNormal];
    }
    
    return _confirmButton;
}

- (VipEditCell *)phoneCell {
    if (!_phoneCell) {
        _phoneCell = [[VipEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _phoneCell.maxEditCount = 11;
        _phoneCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneCell setIcon:[UIImage imageNamed:@"vip_phone_normal"] editedIcon:[UIImage imageNamed:@"vip_phone_selected"] placeholder:@"输入手机号"];
    }
    return _phoneCell;
}

- (VipEditCell *)nameCell {
    if (!_nameCell) {
        _nameCell = [[VipEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_nameCell setIcon:[UIImage imageNamed:@"vip_name_normal"] editedIcon:[UIImage imageNamed:@"vip_name_selected"] placeholder:@"输入姓名"];
    }
    return _nameCell;
}

- (VipEditCell *)ageCell {
    if (!_ageCell) {
        _ageCell = [[VipEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_ageCell setEditAble:NO];
        [_ageCell setIcon:[UIImage imageNamed:@"vip_age_normal"] editedIcon:[UIImage imageNamed:@"vip_age_selected"] placeholder:@"选择年龄段"];
    }
    return _ageCell;
}

- (VipEditCell *)addressCell {
    if (!_addressCell) {
        _addressCell = [[VipEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_addressCell setEditAble:NO];
        [_addressCell setIcon:[UIImage imageNamed:@"vip_address_normal"] editedIcon:[UIImage imageNamed:@"vip_address_selected"] placeholder:@"选择省、市、区"];
    }
    return _addressCell;
}

- (VipSexSelectCell *)sexCell {
    if (!_sexCell) {
        _sexCell = [[VipSexSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    return _sexCell;
}

@end
