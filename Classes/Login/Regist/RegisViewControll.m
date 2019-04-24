//
//  RegisViewControll.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/26.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "RegisViewControll.h"
#import <MBProgressHUD.h>
#import "ValidatorUtil.h"
#import "AgreeMmentViewController.h"
#import "LoginViewControll.h"
#import "LoginApi.h"
#import "User.h"
#import <UMSocial.h>
#import "QqwPersonalViewController.h"
@interface RegisViewControll ()<UITextFieldDelegate,ApiRequestDelegate>

@property (nonatomic,strong)MBProgressHUD *hub;

//完成注册按钮
@property (weak, nonatomic) IBOutlet UIButton *finishRegis;
//手机号图标

@property (weak, nonatomic) IBOutlet UIButton *telephone;
//验证码图标

@property (weak, nonatomic) IBOutlet UIButton *var;
//密码图标

@property (weak, nonatomic) IBOutlet UIButton *password;
//同意条款

@property (weak, nonatomic) IBOutlet UIButton *agree;

//电话号码
@property (weak, nonatomic) IBOutlet UITextField *telephoneText;
//验证码

@property (weak, nonatomic) IBOutlet UITextField *varText;
//获取验证码按钮

@property (weak, nonatomic) IBOutlet UIButton *optionVarButton;

//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

//同意条款按钮

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)NSInteger timeCount;



@property (nonatomic,strong)LoginApi *loginApi;


@end

@implementation RegisViewControll




- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [MobClick endLogPageView:@"regisPage"];
    
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"regisPage"];

    
    self.telephoneText.delegate = self;
    self.telephoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.telephoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.varText.delegate = self;
    self.varText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.varText.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordText.delegate = self;
    self.passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordText.secureTextEntry = YES;
    self.agreeButton.selected = YES;
 
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;

}


#pragma 监听文本框是否输入内容

-(void)teletextFieldChange:(id)sender{
    self.telephone.selected = !self.telephone.selected;
    
    if (self.telephoneText.text.length==11) {
        //  1. 登录按钮变为可点击状态
        self.telephone.selected = YES;
        self.optionVarButton.enabled = YES;
     
        self.optionVarButton.backgroundColor = HexColor(0x53A020);
        
    }else
    {

        self.telephone.selected = NO;
        self.optionVarButton.enabled = NO;
        self.optionVarButton.backgroundColor = HexColor(0xCCCCCC);
        
    }
    
    
}


-(void)vartextFieldChange:(id)sender
{
    
    self.varText.selected = !self.varText.selected;
    
    if (self.varText.text.length==4) {
        //  1. 登录按钮变为可点击状态
        self.var.selected = YES;
        
    }else
    {
        
        self.var.selected = NO;
        
    }
    
    
}

-(void)passwordTextFieldChange:(id)sender
{
    

    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self.passwordText.text dataUsingEncoding:enc];
    
    if (da.length > 5 &&da.length <= 16) {
        //  1. 登录按钮变为可点击状态
        self.password.selected = YES;
        self.finishRegis.enabled = YES;
        self.finishRegis.enabled = YES;
        self.finishRegis.alpha = 1;
        
    }else
    {
        self.password.selected = NO;
        self.finishRegis.enabled = NO;
        self.finishRegis.alpha = 0.4;
        
    }
    
}

- (IBAction)agreeAction:(id)sender {
    
    self.agreeButton.selected = !self.agreeButton.selected;
    
    if (self.agreeButton.selected == YES) {
        self.finishRegis.enabled= YES;
        self.finishRegis.alpha =1.0;
        
    }else{
        self.finishRegis.enabled= NO;
        self.finishRegis.alpha =0.4;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.navigationController.navigationBarHidden = NO;
    
    self.finishRegis.layer.cornerRadius = 20;
    //
    
    [self.telephoneText  addTarget:self action:@selector(teletextFieldChange:)forControlEvents:UIControlEventEditingChanged];
     
     [self.varText  addTarget:self action:@selector(vartextFieldChange:)forControlEvents:UIControlEventEditingChanged];
     [self.passwordText  addTarget:self action:@selector(passwordTextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    
    self.optionVarButton.enabled = NO;
    self.optionVarButton.backgroundColor = HexColor(0xCCCCCC);
    self.finishRegis.enabled = NO;
    self.finishRegis.backgroundColor = HexColor(0x5CB531);
    
    self.agree.selected = YES;
}

- (LoginApi *)loginApi {
    if (!_loginApi) {
        _loginApi = [[LoginApi alloc] init];
        _loginApi.delegate = self;
    }
    return _loginApi;
}

-(void)toast:(NSString *)title
{
    //    int seconds = 3;
    //    [self toast:title seconds:seconds];
    [Utils showErrorMsg:self.view type:0 msg:title];
}

-(void)toastWithError:(NSError *)error
{
    NSString *errorStr = [NSString stringWithFormat:@"网络出错：%@，code：%ld", error.domain, (long)error.code];
    [self toast:errorStr];
}


// 获取验证码
- (IBAction)getVarCode:(id)sender {
  
    [self.view endEditing:YES];
    
#pragma mark- 友盟事件统计
    
    [MobClick event:kEventRegisterGetVerifyCode];
    
#pragma mark- 获取验证码
    
    NSError *error = nil;
    if (![ValidatorUtil isValidMobile:self.telephoneText.text error:&error]) {
        [self toast:[error localizedDescription]];
        return;
    }
    
    [SMSInfo requestSMSWithPhone:self.telephoneText.text type:1 superView:self.view finshBlock:^(id obj, NSError *error) {
        self.timeCount = 60;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:sender repeats:YES];
    }];

}


-(void)reduceTime:(NSTimer *)codeTimer
{
    self.timeCount--;
    if (self.timeCount == 0) {
        [_optionVarButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [_optionVarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *info = codeTimer.userInfo;
        info.enabled = YES;
        _optionVarButton.userInteractionEnabled = YES;
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%lu秒", (long)self.timeCount];
        [_optionVarButton setTitle:str forState:UIControlStateNormal];
        _optionVarButton.userInteractionEnabled = NO;
        
    }
}



//注册

- (IBAction)registerAction:(id)sender {
    
    [self.view endEditing:YES];
    
#pragma mark- 友盟事件统计
    
    [MobClick event:kEventRegisterFinished];
    
#pragma mark - 完成注册
    
    NSError *error = nil;
    
    BOOL p =  [ValidatorUtil isPassword:self.passwordText.text];
    
    if (![ValidatorUtil isValidMobile:self.telephoneText.text error:&error]) {
        [self toast:[error localizedDescription]];
        return;
    }
    if (self.passwordText.text.length <= 0) {
        [self toast:@"密码不能为空"];
        return;
    }
    if (![ValidatorUtil isValidPassword:self.passwordText.text error:&error]) {
        [self toast:[error localizedDescription]];
        return;
    }
    if (!p) {
          [self toast:@"密码为6-16位数字和字母的组合"];
        return;
        
    }
    
    
    [UserRequestApi requestRegisterWithPhone:self.telephoneText.text password:[self.passwordText.text MD5String]  varCode:self.varText.text superView:self.view finshBlock:^(id obj, NSError *error) {
           [self.loginApi loginWithPhone:self.telephoneText.text password:[self.passwordText.text MD5String]];
    }];
    
}



- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    
    
    if (api == _loginApi) {
        NSString *code = command.response.code;
        if ([code isEqualToString:@"0"]) {
            [Utils removeHudFromView:self.view];
            //登录成功后保存用户信息
            User *user = [User mj_objectWithKeyValues:responsObject];
            NSLog(@"用户的手机号%@",user.mobile);
            
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
                NSLog(@"%@", response.allHeaderFields);
            }
            
            
            [User setLocalUser:user];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotify object:nil];
            [MobClick profileSignInWithPUID:[User LocalUser].uid];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}





- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    if (api == _loginApi) {
        [Utils removeAllHudFromView:self.view];
        [Utils postMessage:command.response.msg onView:self.view];
    }
    
}



//同意隐私和条款

- (IBAction)readAgree:(id)sender {
    
    AgreeMmentViewController *agree = [[AgreeMmentViewController alloc]init];
    [self.navigationController pushViewController:agree animated:YES];
    
    
}




@end
