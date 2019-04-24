//
//  LoginViewControll.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/26.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "LoginViewControll.h"
#import "RegisViewControll.h"
#import "ForgetViewController.h"
#import "LoginApi.h"
#import "WXloginApi.h"
#import "QQLoginApi.h"
#import <MBProgressHUD.h>
#import "ValidatorUtil.h"
#import "TelephoneVarViewController.h"
#import "User.h"
#import <UMSocial.h>
#import "RootManager.h"
#import "OrderCountModel.h"
#import "GetPersonInfoApi.h"
@interface LoginViewControll ()<UITextFieldDelegate,ApiRequestDelegate>

//关闭登录页面
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
//登录按钮
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
//手机号图标
@property (weak, nonatomic) IBOutlet UIButton *telephone;
//密码图标
@property (weak, nonatomic) IBOutlet UIButton *password;
//手机号
@property (weak, nonatomic) IBOutlet UITextField *telephoneText;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UIButton *resiBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassWordButton;
@property (weak, nonatomic) IBOutlet UILabel *otherLogin;

@property (nonatomic,strong)LoginApi *loginApi;
@property (nonatomic,strong)WXloginApi *wxLogin;
@property (nonatomic,strong)QQLoginApi *qqLogin;
@property (nonatomic,strong)MBProgressHUD *hub;
@property (nonatomic,strong)GetPersonInfoApi *getInfoApi;
@end

@implementation LoginViewControll

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [MobClick beginLogPageView:@"loginPage"];

}

- (GetPersonInfoApi *)getInfoApi{
    if (!_getInfoApi) {
        _getInfoApi = [[GetPersonInfoApi alloc]init];
        _getInfoApi.delegate = self;
        
    }
    return _getInfoApi;
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
     [MobClick endLogPageView:@"loginPage"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.telephoneText.delegate = self;
    self.telephoneText.keyboardType = UIKeyboardTypeNumberPad;
    
    self.telephoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordText.delegate = self;
    self.passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordText.secureTextEntry = YES;
    
}

#pragma mark ================== Textfield delegate =================
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.LoginButton.layer.cornerRadius =20;
    self.LoginButton.layer.masksToBounds = YES;
    self.LoginButton.alpha = 0.4;
    self.LoginButton.enabled = NO;
    
    [self.telephoneText  addTarget:self action:@selector(teletextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    [self.passwordText  addTarget:self action:@selector(passwordTextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    //登录按钮默认不可用，
    
    [self.resiBtn setTitleColor:HexColor(0x323232) forState:UIControlStateNormal];
    [self.forgetPassWordButton setTitleColor:HexColor(0x323232) forState:UIControlStateNormal];
    self.otherLogin.textColor =HexColor(0x323232);
    
    // Do any additional setup after loading the view from its nib.
}


-(void)teletextFieldChange:(id)sender{
    self.telephone.selected = !self.telephone.selected;
        if (self.telephoneText.text.length==11) {
        //  1. 登录按钮变为可点击状态
        self.telephone.selected = YES;
        
    }else{
        self.telephone.selected = NO;
        
    }

}

-(void)passwordTextFieldChange:(id)sender{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self.passwordText.text dataUsingEncoding:enc];
    
    if (da.length > 5 &&da.length <= 16) {
        
        //  1. 登录按钮变为可点击状态
        self.password.selected = YES;
        self.LoginButton.enabled = YES;
        
        self.LoginButton.alpha = 1;
        self.LoginButton.enabled = YES;
        
    }else
    {
        self.password.selected = NO;
        self.LoginButton.enabled = NO;
        self.LoginButton.alpha = 0.4;
        self.LoginButton.enabled = NO;
    }

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];
}

// 关闭登录页面

- (IBAction)closeLoginViewController:(id)sender {
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
//注册页面

- (IBAction)registeraction:(id)sender {
    
#pragma mark- 友盟事件统计
    
    [MobClick event:kEventRegister];
    
#pragma mark- 跳转到注册页面
    
    RegisViewControll *regist = [[RegisViewControll alloc]init];
    [self.navigationController pushViewController:regist animated:YES];

}

//忘记密码页面
- (IBAction)forgettenAction:(id)sender {
    ForgetViewController *forget = [[ForgetViewController alloc]init];
    [self.navigationController pushViewController:forget animated:YES];

}

//登录操作
- (LoginApi *)loginApi {
    if (!_loginApi) {
        
        _loginApi = [[LoginApi alloc] init];
        _loginApi.delegate = self;
    }
    return _loginApi;
}

-(void)toast:(NSString *)title{
    [Utils showErrorMsg:self.view type:0 msg:title];
}

- (IBAction)LoginAction:(id)sender {
    [self.view endEditing:YES];
    NSError *error = nil;
    
    if (![ValidatorUtil isValidMobile:self.telephoneText.text error:&error]) {
        [self toast:[error localizedDescription]];
        return;
    }
    //加密
    BOOL p =  [ValidatorUtil isPassword:self.passwordText.text];
    if (p) {
        [Utils addHudOnView:self.view];
        [self.loginApi loginWithPhone:self.telephoneText.text password:[self.passwordText.text MD5String]];
        
        NSDictionary *dict = @{@"telephoneText" : @"telephoneText.text", @"passwordText" : @"passwordText.text"};
        [MobClick event:@"login" attributes:dict];
        
    }else{
        [self toast:@"密码为6-16位数字和字母的组合"];
    }
    
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {

    if (api == _loginApi) {
        
        NSLog(@"%@",command.response.code);
        
        [Utils removeHudFromView:self.view];
        //登录成功后保存用户信息
        
        NSLog(@"changguidenglu%@",responsObject);
        User *user = [User mj_objectWithKeyValues:responsObject];
        
        NSLog(@"用户的手机号%@\n token = %@",user.mobile,user.token);
        
        if ([command.task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)command.task.response;
            NSString *cookieString = [response.allHeaderFields objectForKey:@"Set-Cookie"];
            
            NSArray *array = [cookieString componentsSeparatedByString:@";"];
            
            for (NSString *str in array) {
                NSArray *subArray = [str componentsSeparatedByString:@"="];
                if ([[subArray safeObjectAtIndex:0] isEqualToString:@"__TOKEN"]) {
                    user.token = [subArray safeObjectAtIndex:1];
                    break;
                    
                }
            }
             NSLog(@"用户的token = %@",user.token);
        }
        
        
        [User setLocalUser:user];
        
#pragma mark- 在激光推送中为了将registerID设置在个人资料里，需要重新对用户信息进行设置
        [self.getInfoApi userInfoWithNikeName:[User LocalUser].nickname sex:[User LocalUser].sex face:[User LocalUser].face province:[User LocalUser].province city:[User LocalUser].city distrction:[User LocalUser].district registerId:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"]];
        
        //拉用户数据，存到localuser里， 然后就是：
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotify object:nil];
        [MobClick profileSignInWithPUID:[User LocalUser].uid];
        
        [self dismissViewControllerAnimated:YES completion:^{
            if ([[User LocalUser].role isEqualToString:kUserRoleVip] && ![[User LocalUser] hasSteward]) {
                StewardSelectViewController *vc = [[StewardSelectViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                UINavigationController *nav = (UINavigationController *)[RootManager sharedManager].tabbarController.selectedViewController;
                [nav pushViewController:vc animated:YES];
            }
        }];
    }
    
    if (api == _wxLogin) {
        
#pragma mark- 友盟事件统计
        
        [MobClick event:kEventWXLogin];
        
#pragma mark -微信登录绑定手机号事件
        NSLog(@"微信登录%@",responsObject);
        
        if ([[responsObject objectForKey:@"ismobile"]isEqualToString:@"0"]) {
            
            if ([command.task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)command.task.response;
                NSString *cookieString = [response.allHeaderFields objectForKey:@"Set-Cookie"];
                [User LocalUser].cookieString = cookieString;
                NSArray *array = [cookieString componentsSeparatedByString:@";"];
                
                for (NSString *str in array) {
                    NSArray *subArray = [str componentsSeparatedByString:@"="];
                    if ([[subArray safeObjectAtIndex:0] isEqualToString:@"__TOKEN"]) {
                        [User LocalUser].token = [subArray safeObjectAtIndex:1];
                        
                        NSLog(@"token%@",[User LocalUser].token);
                        
                        break;
                        
                    }
                }
                NSLog(@"%@", response.allHeaderFields);
            }
            
            TelephoneVarViewController *bindingTelephone = [[TelephoneVarViewController alloc]init];
            bindingTelephone.dic = responsObject;
            bindingTelephone.token =[User LocalUser].token;
            
            [self.navigationController pushViewController:bindingTelephone animated:YES];
            
        }else if ([[responsObject objectForKey:@"ismobile"]isEqualToString:@"1"])
        {
            //登录成功后保存用户信息
            
            User *user = [User mj_objectWithKeyValues:responsObject];
            if ([command.task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)command.task.response;
                NSString *cookieString = [response.allHeaderFields objectForKey:@"Set-Cookie"];
                user.cookieString = cookieString;
                NSArray *array = [cookieString componentsSeparatedByString:@";"];
                for (NSString *str in array) {
                    NSArray *subArray = [str componentsSeparatedByString:@"="];
                    if ([[subArray safeObjectAtIndex:0] isEqualToString:@"__TOKEN"]) {
                        user.token = [subArray safeObjectAtIndex:1];
                        
                        NSLog(@"token%@",user.token);
                        
                        break;
                        
                    }
                }
                NSLog(@"%@", response.allHeaderFields);
            }
            
            [User setLocalUser:user];
            
            [User LocalUser].ismobile = YES;
            [User saveToDisk];
            
#pragma mark- 在激光推送中为了将registerID设置在个人资料里，需要重新对用户信息进行设置
            [self.getInfoApi userInfoWithNikeName:[User LocalUser].nickname sex:[User LocalUser].sex face:[User LocalUser].face province:[User LocalUser].province city:[User LocalUser].city distrction:[User LocalUser].district registerId:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"]];
            
            [self dismissViewControllerAnimated:YES completion:^{
                if ([[User LocalUser].role isEqualToString:kUserRoleVip] && ![[User LocalUser] hasSteward]) {
                    StewardSelectViewController *vc = [[StewardSelectViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    UINavigationController *nav = (UINavigationController *)[RootManager sharedManager].tabbarController.selectedViewController;
                    [nav pushViewController:vc animated:YES];
                    
                }
            }];
            
        }
        
    }
    
    if (api == _getInfoApi) {
        
        NSLog(@"提交注册id后，确保个人资料是有的%@",responsObject);
        [User LocalUser].nickname = responsObject[@"nickname"];
        [User LocalUser].sex = responsObject[@"sex"];
        [User LocalUser].face = responsObject[@"face"];
        [User LocalUser].province = responsObject[@"province"];
        [User LocalUser].city = responsObject[@"city"];
        [User LocalUser].district = responsObject[@"district"];
        [User LocalUser].registerId = responsObject[@"token"];
        //推送的注册ID
        [User saveToDisk];
        
    }
    
    
    
}



- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils removeAllHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
    
    
}

- (WXloginApi *)wxLogin
{

    if (!_wxLogin) {
        _wxLogin = [[WXloginApi alloc] init];
        _wxLogin.delegate = self;
    }
    return _wxLogin;
    
}

- (QQLoginApi *)qqLogin
{

    if (!_qqLogin) {
        _qqLogin = [[QQLoginApi alloc]init];
        _qqLogin.delegate = self;
    }
    return _qqLogin;
}


//微信登录
- (IBAction)wxLogin:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];

    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [dict valueForKey:snsPlatform.platformName];
            [self.wxLogin wxLoginWithNikeName:snsAccount.userName openId:snsAccount.unionId sex:[response.thirdPlatformUserProfile objectForKey:@"sex"] face:[response.thirdPlatformUserProfile objectForKey:@"headimgurl"] type:@"appWechat"];
        }
    });
}






@end
