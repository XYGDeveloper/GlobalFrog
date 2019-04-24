//
//  SetAppViewController.m
//  Qqw
//
//  Created by XYG on 16/8/15.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "SetAppViewController.h"
#import "ExitTableViewCell.h"
#import "LoginViewControll.h"
#import "ServiceBackViewController.h"
#import "QqwPersonalViewController.h"
#import "User.h"
#import "ValidatorUtil.h"
#import "ShareManager.h"
#import "ModifyPasswordViewController.h"
#import "ShareView.h"
@interface SetAppViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UISwitch * switchView;
}

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)User *userInfo;


@property (nonatomic,assign)float cameNumber;

@property (nonatomic,strong)NSString *clearInfo;

@end

@implementation SetAppViewController

static NSString *const pushCellIdentity = @"pushCellIdentity";

-(void)toast:(NSString *)title{

    [Utils showErrorMsg:self.view type:0 msg:title];
}

-(void)toastWithError:(NSError *)error{
    NSString *errorStr = [NSString stringWithFormat:@"网络出错：%@，code：%ld", error.domain, (long)error.code];
    [self toast:errorStr];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
 
    // 判断是否为第一次使用此APP
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Boot.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    BOOL notFirstUse = YES;
    notFirstUse = [dic[@"notFirstUse"] boolValue];
    if (!notFirstUse) {
        NSDictionary *dic = @{@"notFirstUse" : @"YES" };
        [dic writeToFile:filePath atomically:YES];
    }else{
        
    }
    _cameNumber = [[SDImageCache sharedImageCache] getSize] / 1024 / 1024.;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switchView = [UISwitch new];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
            [switchView setOn:NO];
        }else{
            [switchView setOn:YES];
        }
    }else{
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone) {
            [switchView setOn:NO];
        }else{
            [switchView setOn:YES];
        }
    }
    
    [switchView addTarget:self action:@selector(setPushAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = DefaultBackgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"ExitTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView reloadData];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if ([User hasLogin]== YES) {
        
        return 2;
        
    }else
    {
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if ([User hasLogin]) {
        
        if (section == 0) {
            return 6;
            
        }else
        {
            return 1;
        }
        
    }else
    {
    
        return 4;
    }

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * celliden = @"seachCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celliden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:celliden];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.font =[UIFont systemFontOfSize:14.0f];
    cell.textLabel.textColor =HexColorA(0x323232,0.8);
    cell.detailTextLabel.text = nil;
    cell.accessoryView = nil;
    if ([User hasLogin]== YES) {
        
        if (indexPath.section == 0&& indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"修改密码";
            
        }else if (indexPath.section == 0&& indexPath.row == 1){
            cell.textLabel.text = @"清楚缓存";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",_cameNumber];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }else if (indexPath.section == 0&& indexPath.row == 2){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"分享APP";
        }else if (indexPath.section == 0&& indexPath.row == 3){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"服务与反馈";
        }else if (indexPath.section == 0&& indexPath.row == 4){
            cell.textLabel.text = @"消息推送";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = switchView;
            
        }else if (indexPath.section == 0&& indexPath.row == 5){
            
            cell.textLabel.text = @"关于全球蛙";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.section == 1&&indexPath.row == 0){
            
            ExitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.textLabel.textColor =HexColorA(0x323232,0.8);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
            UIButton *Exit =  [cell viewWithTag:1000];
            [Exit setTitleColor:HexColorA(0x323232,1.0) forState:UIControlStateNormal];
            [Exit addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            
        }
        return cell;
        
    }else{
        if (indexPath.section == 0&& indexPath.row == 0){
            cell.textLabel.text = @"清楚缓存";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",_cameNumber];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }else if (indexPath.section == 0&& indexPath.row == 1){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"分享APP";
            
        }else if (indexPath.section == 0&& indexPath.row == 2){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"服务与反馈";
            
        }else if (indexPath.section == 0&& indexPath.row == 3){
            
            cell.textLabel.text = @"关于全球蛙";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([User hasLogin]== YES) {
        
        if (indexPath.section == 0&& indexPath.row == 0) {
            
            if ([Utils showLoginPageIfNeeded]) {
                
                
            } else {
                
                ModifyPasswordViewController *modify = [[ModifyPasswordViewController alloc]init];
                
                modify.title = @"修改密码";
                modify.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:modify animated:YES];
            }
            
        }else if (indexPath.section == 0&& indexPath.row == 1)
        {
            [self cleanCache];
            
        }else if (indexPath.section == 0&& indexPath.row == 2)
        {
            [self share];
            
        }else if (indexPath.section == 0&& indexPath.row == 3)
        {
            ServiceBackViewController *service = [[ServiceBackViewController alloc]init];
            service.hidesBottomBarWhenPushed = YES;
            service.title = @"服务与反馈";
            [self.navigationController pushViewController:service animated:YES];
            
        }else if (indexPath.section == 0&& indexPath.row == 4)
        {
            
          //消息推送
            
        }else if (indexPath.section == 0&& indexPath.row == 5)
        {
            
            WebViewController *aboutVC = [[WebViewController alloc] initWithURLString:H5URL(@"/static/qqw_about.htm")];
            aboutVC.openURLInNewController = NO;
            aboutVC.title = @"关于全球蛙";
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
        
        }
        
        else if (indexPath.section == 1&&indexPath.row == 0)
        {
            
            
            if ([Utils showLoginPageIfNeeded]) {
                
            } else {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
        
    }else
    {
    
    
        if (indexPath.section == 0&& indexPath.row == 0)
        {
           
            [self cleanCache];
            

        }else if (indexPath.section == 0&& indexPath.row == 1)
        {
          
            [self share];

        }else if (indexPath.section == 0&& indexPath.row == 2)
        {
           
            ServiceBackViewController *service = [[ServiceBackViewController alloc]init];
            service.hidesBottomBarWhenPushed = YES;
            service.title = @"服务与反馈";
            [self.navigationController pushViewController:service animated:YES];
            
            
        }else if (indexPath.section == 0&& indexPath.row == 3)
        {
            
            WebViewController *aboutVC = [[WebViewController alloc] initWithURLString:H5URL(@"/static/qqw_about.htm")];
            aboutVC.openURLInNewController = NO;
            aboutVC.title = @"关于全球蛙";
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }
}


- (void)back:(UIButton *)btn{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


- (void)cleanCache{
    _cameNumber = 0;

    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [Utils showErrorMsg:self.view type:0 msg:@"已清空缓存"];
        [self.tableView reloadData];
    }];
    [User saveToDisk];
    [self.tableView reloadData];
}


- (void)share {
    [ShareManager shareWithType:@"5" identifier:@"" inViewController:self];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        [UserRequestApi requestSaveLogOutWithSuperView:nil finshBlock:^(id obj, NSError *error) {
            [User clearLocalUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccessNotify object:nil];
            
            [self.navigationController popToRootViewControllerAnimated:NO];
        }];
    }
}

- (void)setPushAction:(UISwitch *)swi{
    if (swi.on) {
        if ([[UIDevice currentDevice].systemVersion floatValue] >=8.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }else{
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        }
    }else{
        UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"关闭消息推送" message:@"关闭推送后将不能及时收到订单发货或优惠信息，是否关闭" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
            if (buttonIndex != zg_alertView.cancelButtonIndex) {
                if ([[UIDevice currentDevice].systemVersion floatValue] >=8.0) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }else{
                    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
                }
            }else{
                [swi setOn:YES];
            }
        }];
        
        [alertView show];
    }
   

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
