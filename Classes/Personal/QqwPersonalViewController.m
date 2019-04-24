//
//  QqwPersonalViewController.m
//  Qqw
//  Created by 全球蛙 on 16/7/15.
//  Copyright © 2016年 gao.jian. All rights reserved.
//
#import "QqwPersonalViewController.h"
#import "QqwPersonalCell.h"
#import "AddressViewController.h"
#import "SetAppViewController.h"
#import "ServiceBackViewController.h"
#import "LoginViewControll.h"
#import "QqwPersonalDataEditController.h"
#import "OrderListContainerViewController.h"
#import "ShopCollectViewController.h"
#import "ComponViewController.h"
#import "User.h"
#import "WebViewController.h"
#import "ButterTableViewCell.h"
#import "BecomeVipViewController.h"
#import "OrderCountModel.h"
#import "QqwAttentionViewController.h"
#import "MyInfoViewController.h"
#import "RealNameAuthViewController.h"
typedef void (^getRequestData)(NSDictionary *dic);
@interface QqwPersonalViewController () <UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
@property (nonatomic,strong)NSDictionary *orderDic;
@property (nonatomic,strong)OrderCountModel *model;
@property (nonatomic,strong)getRequestData data;
//@property (nonatomic,strong)NSDictionary *infoDic;

@end

@implementation QqwPersonalViewController
static NSString* cellID = @"PersonalTableViewCellID";
static NSString* personalCellID = @"QqwPersonalCellID";
static NSString* butterCellID = @"ButterCell";
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kJumpToOrderListPageNotify object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess:) name:kLoginSuccessNotify object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut:) name:kLogoutSuccessNotify object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationRecieved:) name:kModifyPasswordSuccessNotify object:nil];
        
        
    }
    return self;
    
}
-(void)initView{
    
    self.view.backgroundColor = HexColorA(0xf3f3f3,1);
    
    /*初始化个人中心表*/
    self.personTableView =({
        
        UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 205, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        [tableView registerClass:[QqwPersonalCell class] forCellReuseIdentifier:personalCellID];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:butterCellID];
        
        [self.view addSubview:tableView];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(0);
             make.left.right.mas_equalTo(0);
             make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
             
         }];
        
        tableView;
    });
    
    /*初始化表头*/
    self.headView= [[QqwPersonalHeadView alloc] init];
    
    self.headView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 230);
    self.personTableView.backgroundColor = HexColorA(0xf3f3f3,1);
    self.personTableView.tableHeaderView.backgroundColor =[UIColor colorWithRed:0.169 green:0.600 blue:0.141 alpha:1.000];
    
    
    if ([User hasLogin] == YES && [self.model.msgs intValue] > 0) {
        self.headView.noticeInfo.backgroundColor = HexColor(0xd63d3e);
    }else{
        self.headView.noticeInfo.backgroundColor =[UIColor clearColor];
    }
    
    [self.view addSubview:self.headView];
    self.personTableView.contentInset = UIEdgeInsetsMake(195, 0, 0, 0);
    self.personTableView.scrollIndicatorInsets = self.personTableView.contentInset;
    
    __weak QqwPersonalViewController *person = self;
    
    weakify(self);
    self.headView.attention = ^(){
        strongify(self);
        if (![Utils showLoginPageIfNeeded]) {
            ShopCollectViewController *shopCollect = [[ShopCollectViewController alloc]init];
            shopCollect.hidesBottomBarWhenPushed = YES;
            shopCollect.title = @"我的收藏";
            [self.navigationController pushViewController:shopCollect animated:YES];
        }
    };
    
    self.headView.collection = ^(){
        strongify(self);
        if (![Utils showLoginPageIfNeeded]) {
            QqwAttentionViewController *attention = [[QqwAttentionViewController alloc]init];
            attention.title = @"我的关注";
            [self.navigationController pushViewController:attention animated:YES];
        }
    };
    
    self.headView.info = ^(){
        strongify(self);
        if (![Utils showLoginPageIfNeeded]) {
            MyInfoViewController *myInfo = [MyInfoViewController new];
            [self.navigationController pushViewController:myInfo animated:YES];
        }
        
    };
    self.headView.labelTouch = ^(){
        
    };
    /*点击头部头像事件回调*/
    
    self.headView.touchAction = ^(){
        
        if ([Utils showLoginPageIfNeeded]) {} else {
            QqwPersonalDataEditController *edit = [[QqwPersonalDataEditController alloc]init];
            edit.hidesBottomBarWhenPushed = YES;
            [person.navigationController pushViewController:edit animated:YES];
        }
    };
    
    
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([User hasLogin]== YES) {
        [self.headView setHeadImage:[User LocalUser].face withLeve:[User LocalUser].butler_name withAccountName:[User LocalUser].nickname];
        
        [OrderCountModel requestOrderCountWithSuperView:nil finshBlock:^(OrderCountModel *obj, NSError *error) {
            self.model = obj;
            [self.headView.attentionButton setTitle:[NSString stringWithFormat:@"收藏 %@",self.model.collections] forState:UIControlStateNormal];
            
            [self.headView.collectionButton setTitle:[NSString stringWithFormat:@"关注 %@",self.model.follows] forState:UIControlStateNormal];
            [self.personTableView reloadData];
        }];
    }else{
        [self.headView setHeadImage:nil withLeve:nil withAccountName:@"登录/注册"];
        [self.headView.attentionButton setTitle:@"收藏" forState:UIControlStateNormal];
        [self.headView.collectionButton setTitle:@"关注" forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ================== noty =================
- (void)loginSuccess:(NSNotification *)loginSuccess{
    if ([loginSuccess.name isEqualToString:kLoginSuccessNotify]) {
        [self.personTableView reloadData];
    }
}

//登出通知
- (void)loginOut:(NSNotification *)loginOut{

    if ([loginOut.name isEqualToString:kLogoutSuccessNotify]) {
        [self.personTableView reloadData];
    }
}

- (void)notificationRecieved:(NSNotification *)note {
    if ([note.name isEqualToString:kJumpToOrderListPageNotify]) {//跳转到订单列表
        [Utils jumpToTabbarControllerAtIndex:3];
        
        NSString *reqStatus = [note object];
        OrderListContainerViewController *vc = [[OrderListContainerViewController alloc] init];
        vc.orderStatus = reqStatus;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([note.name isEqualToString:kModifyPasswordSuccessNotify]) {//修改密码成功后，退出登陆，并弹出登陆窗口
        [self.navigationController popToRootViewControllerAnimated:NO];
        [Utils showLoginPageIfNeeded];
    }
}

#pragma mark ================== scrollView delegate =================
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = self.personTableView.contentOffset.y + self.personTableView.contentInset.top;
    if (offset <= 0) {
        self.headView.mj_y = 0;
        self.headView.height = 230 - offset;
        self.headView.bgImg.height = self.headView.height;
    }else{
        self.headView.height = 230;
        self.headView.bgImg.height = self.headView.height;
        self.headView.mj_y = -offset;
    }
}

#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if(section == 1){
        return 10;
    }
    return 0.1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 2;
    }
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1){
        return 60.0f;
    }
    return 50.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==1){
        __block QqwPersonalViewController* this = self;
        
        QqwPersonalCell* cell = [tableView dequeueReusableCellWithIdentifier:personalCellID forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btnAction = ^(NSInteger index){
            [this waitButtonAction:index];
        };
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.model = self.model;
        return cell;
    }else{
        if(indexPath.section == 1&& indexPath.row == 1){
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:butterCellID];
            UILabel* accessoryLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,120,30.0f)];
            accessoryLab.textAlignment = NSTextAlignmentRight;
            accessoryLab.textColor = [UIColor lightGrayColor];
            cell.imageView.image = [UIImage imageNamed:@"1-2"];
            accessoryLab.userInteractionEnabled = YES;
            cell.accessoryView = accessoryLab;
            accessoryLab.textColor =HexColorA(0x323232,0.8);
            accessoryLab.font = [UIFont systemFontOfSize:15.0f];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor =HexColorA(0x323232,0.8);
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            if ([User hasLogin]== YES) {
                if (![[User LocalUser].isbus isEqualToString:@"1"]) {
                    
                    if ([[User LocalUser].role isEqualToString:kUserRoleNormal]) {
                        
                        cell.textLabel.text = @"我的管家";
                        accessoryLab.userInteractionEnabled = NO;
                    }
                    
                    if ([[User LocalUser].role isEqualToString:kUserRoleVip]){
                        
                        cell.textLabel.text = [NSString stringWithFormat:@"管家：%@",[User LocalUser].butler_name];
                        accessoryLab.text = [User LocalUser].butler_mobile;
                        
                        if (![[User LocalUser].butler_mobile isEqualToString:@""]) {
                            
                            [accessoryLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telephAction:)]];
                        }
                    }
                    
                    if ([[User LocalUser].role isEqualToString:kUserRoleSteward] || [[User LocalUser].role isEqualToString:kUserRoleSteward1]){
                        
                        cell.textLabel.text = @"管家助手";
                        accessoryLab.text = @"";
                        accessoryLab.userInteractionEnabled = NO;
                        
                    }
                    
                }else{
                    
                    cell.textLabel.text = @"商家助手";
                    accessoryLab.text = @"";
                    
                }
                
            }else{
                
                cell.textLabel.text = @"管家助手";
                accessoryLab.text = @"";
            }
            
            
            return cell;
            
        }
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
        cell.textLabel.textColor =HexColorA(0x323232,0.8);
        if(indexPath.section == 0){
            if (indexPath.row == 0){
                cell.imageView.image = [UIImage imageNamed:@""];
                cell.textLabel.text = @"我的订单";
                cell.textLabel.font =[UIFont systemFontOfSize:15];
                UILabel* accessoryLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,120,30.0f)];
                accessoryLab.textAlignment = NSTextAlignmentRight;
                accessoryLab.textColor = [UIColor lightGrayColor];
                accessoryLab.text = @"查看全部订单 >";
                accessoryLab.font = [UIFont systemFontOfSize:13];
                cell.accessoryView = accessoryLab;
            }
        }else{
            if (indexPath.row == 0)
            {
                cell.imageView.image = [UIImage imageNamed:@"1-1"];
                cell.textLabel.text = @"我的优惠券";
                
            }
            else if (indexPath.row == 2)
            {
                cell.imageView.image = [UIImage imageNamed:@"1-4"];
                cell.textLabel.text = @"我的地址";
                
            }
            else if (indexPath.row == 3)
            {
                cell.imageView.image = [UIImage imageNamed:@"personal_identityCerficate"];
                cell.textLabel.text = @"实名认证";
            }
            else if (indexPath.row == 4)
            {
            
                cell.imageView.image = [UIImage imageNamed:@"1-5"];
                cell.textLabel.text = @"设置";
            
            }
        
        }
            
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section ==1 && indexPath.row == 4) {
        SetAppViewController *set = [[SetAppViewController alloc]init];
        set.hidesBottomBarWhenPushed = YES;
        set.title = @"设置";
        [self.navigationController pushViewController:set animated:YES];
    }else if (![Utils showLoginPageIfNeeded]) {
        if (indexPath.section == 0 && indexPath.row == 0){
            
            OrderListContainerViewController* avc = [[OrderListContainerViewController alloc] init];
            avc.hidesBottomBarWhenPushed = YES;
            avc.orderStatus = OrderReqStatusAll;
            avc.title = @"我的订单";
            [self.navigationController pushViewController:avc animated:YES];
            
        }else if (indexPath.section == 1 && indexPath.row == 0){
            ComponViewController *cpopon = [[ComponViewController alloc]init];
            cpopon.hidesBottomBarWhenPushed = YES;
            cpopon.title = @"我的优惠券";
            [self.navigationController pushViewController:cpopon animated:YES];
            
        }else if (indexPath.section == 1 && indexPath.row == 1){
            if (![[User LocalUser].isbus isEqualToString:@"1"]) {
                
                if ([[User LocalUser].role isEqualToString:kUserRoleNormal]) {
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"加入成为会员" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    
                    [alert show];
                    
                }else if ([[User LocalUser].role isEqualToString:kUserRoleVip]){
                    
                    if ([[User LocalUser] hasSteward] && ![[User LocalUser].butler_name isEqualToString:@""]) {
                        
                        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"管家：%@",[User LocalUser].butler_mobile] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拨打管家电话" otherButtonTitles:@"添加到通讯录",nil];
                        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                        [actionSheet showInView:self.view];
                    } else {
                        StewardSelectViewController *vc = [[StewardSelectViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                }else if([[User LocalUser].role isEqualToString:kUserRoleSteward] || [[User LocalUser].role isEqualToString:kUserRoleSteward1]){
                    WebViewController *ste = [[WebViewController alloc]initWithURLString:H5_BUTLER_URL];
                    ste.title = @"管家助手";
                    ste.openURLInNewController = NO;
                    ste.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:ste animated:YES];
                }
            }else{
                WebViewController *bus = [[WebViewController alloc]initWithURLString:H5_BUSINESS_URL];
                bus.title = @"商家助手";
                bus.openURLInNewController = NO;
                bus.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:bus animated:YES];
            }
        }else if (indexPath.section == 1 && indexPath.row == 2){
            AddressViewController *address = [[AddressViewController alloc]init];
            address.hidesBottomBarWhenPushed = YES;
            address.title = @"我的地址";
            BOOL entereanceFlage = YES;
            address.flage = entereanceFlage;
            [self.navigationController pushViewController:address animated:YES];
            
        }else if (indexPath.section == 1 && indexPath.row == 3){
            RealNameAuthViewController *Authen = [[RealNameAuthViewController alloc]init];
            Authen.hidesBottomBarWhenPushed = YES;
            BOOL entereanceFlage = YES;
            Authen.flage = entereanceFlage;
            Authen.title = @"实名认证";
            [self.navigationController pushViewController:Authen animated:YES];
        }
    }
}

#pragma mark - buttonAction
- (void)waitButtonAction:(NSInteger)index{
    if (![Utils showLoginPageIfNeeded]){
        OrderListContainerViewController* avc = [[OrderListContainerViewController alloc] init];
        switch (index) {
            case 0:
                avc.orderStatus = OrderReqStatusWaitPay;/*待付款*/
                break;
            case 1:
                avc.orderStatus = OrderReqStatusWaitSend; /*待发货*/
                break;
            case 2:
                avc.orderStatus = OrderReqStatusWaitRecieve;/*待收货*/
                break;
            case 3:
                avc.orderStatus = OrderReqStatusWaitComment;/*待评价*/
                break;
                
            default:
                break;
        }
        [self.navigationController pushViewController:avc animated:YES];
    }
}


- (void)telephAction:(UITapGestureRecognizer*)btn {
    
    if ([User hasLogin] == YES) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:[NSString stringWithFormat:@"管家：%@",[User LocalUser].butler_mobile]
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"拨打管家电话"
                                      otherButtonTitles:@"添加到通讯录",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
        
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 0) {
        
    }else
    {
        BecomeVipViewController*vip = [[BecomeVipViewController alloc]init];
        vip.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vip animated:YES];
        
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
    if (buttonIndex == 0) {
        
        
        [Utils callPhoneNumber:[User LocalUser].butler_mobile];

        
    }else if (buttonIndex == 1)
    {
      
        [Utils addPhoneNumberToAddressBook:[User LocalUser].butler_mobile];
        
    }else
    {
    
        
    }

}


@end
