//
//  TelephoneVarViewController.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "TelephoneVarViewController.h"
#import "BingWXLoginApi.h"
#import <MBProgressHUD.h>
#import "User.h"
#import "ValidatorUtil.h"
#import "GetPersonInfoApi.h"
@interface TelephoneVarViewController ()<ApiRequestDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic,strong)BingWXLoginApi *registerApi;
@property (nonatomic,strong)GetPersonInfoApi *getInfoApi;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger timeCount;
@property (weak, nonatomic) IBOutlet UIButton *optionVar;
@property (weak, nonatomic) IBOutlet UITextField *telephoneText;
@property (weak, nonatomic) IBOutlet UITextField *smscodeText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (nonatomic,strong)MBProgressHUD *hub;

@property (weak, nonatomic) IBOutlet UIButton *telephoneButton;

@property (weak, nonatomic) IBOutlet UIButton *smscodeButton;

@property (weak, nonatomic) IBOutlet UIButton *passwordButton;


@end

@implementation TelephoneVarViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [User clearLocalUser];
    self.telephoneText.delegate  =self;
    self.telephoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.smscodeText.delegate = self;
    self.smscodeText.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordText.delegate  =self;
    self.telephoneText.clearButtonMode  =UITextFieldViewModeWhileEditing;
    self.smscodeText.clearButtonMode  =UITextFieldViewModeWhileEditing;
    self.passwordText.clearButtonMode  =UITextFieldViewModeWhileEditing;
    self.passwordText.secureTextEntry = YES;
}


- (void)viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];


}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.nextButton.layer.cornerRadius = 20;
    self.telephoneText.delegate = self;
    self.smscodeText.delegate = self;
    self.passwordText.delegate = self;
    
    [self.telephoneText  addTarget:self action:@selector(teletextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    
    [self.smscodeText  addTarget:self action:@selector(smsTextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    
    [self.passwordText  addTarget:self action:@selector(passwordTextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    
}

-(void)teletextFieldChange:(id)sender
{
    self.telephoneButton.selected = !self.telephoneButton.selected;
    
    if (self.telephoneText.text.length==11) {
        //  1. 登录按钮变为可点击状态
        self.telephoneButton.selected = YES;
        self.optionVar.enabled = YES;
        self.optionVar.backgroundColor = HexColor(0x53A020);
     
    }else
    {
        
        self.telephoneButton.selected = NO;
        self.optionVar.enabled = NO;
        self.optionVar.backgroundColor = HexColor(0xCCCCCC);
        
    }
    
    
}



-(void)smsTextFieldChange:(id)sender
{
    self.smscodeButton.selected = !self.smscodeButton.selected;
    
    if (self.smscodeText.text.length==4) {
        //  1. 登录按钮变为可点击状态
        self.smscodeButton.selected = YES;
        
    }else
    {
        self.smscodeButton.selected = NO;
        
    }
    
    
}


-(void)passwordTextFieldChange:(id)sender
{
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self.passwordText.text dataUsingEncoding:enc];
    
    if (da.length > 5 &&da.length <= 16) {
        //  1. 登录按钮变为可点击状态
        self.passwordButton.selected = YES;
        
        //下一步按钮的正常状态
        self.nextButton.alpha = 1;
        self.nextButton.enabled = YES;
        
    }else
    {
        self.passwordButton.selected = NO;
        
        //下一步按钮的非正常状态
        self.nextButton.alpha = 0.4;
        self.nextButton.enabled = NO;
    }
    
    
    
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


-(void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    CGRect frame = textField.frame;
    
    int offset = frame.origin.y + 70 - (self.view.frame.size.height - 216.0);//iPhone键盘高度216，iPad的为352
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:0.5f];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    
    if(offset > 0)
        
        self.view.frame = CGRectMake(0.0f, -offset-60, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField

{
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
}

- (BingWXLoginApi *)registerApi
{
    if (!_registerApi) {
        _registerApi  = [[BingWXLoginApi alloc]init];
        _registerApi.delegate  = self;
        
    }
    return _registerApi;
    
}


- (GetPersonInfoApi *)getInfoApi
{
    if (!_getInfoApi) {
        _getInfoApi = [[GetPersonInfoApi alloc]init];
        _getInfoApi.delegate = self;
        
    }
    return _getInfoApi;
}

-(void)toast:(NSString *)title{
    //    int seconds = 3;
    //    [self toast:title seconds:seconds];
    [Utils showErrorMsg:self.view type:0 msg:title];
}

-(void)toastWithError:(NSError *)error{
    NSString *errorStr = [NSString stringWithFormat:@"网络出错：%@，code：%ld", error.domain, (long)error.code];
    [self toast:errorStr];
}

- (IBAction)getVarCode:(id)sender {
    
#pragma mark - 微信绑定获取验证码
    
    [MobClick event:kEventWXLoginGetVerifyCode];
    
    NSError *error = nil;
    if (![ValidatorUtil isValidMobile:self.telephoneText.text error:&error]) {
        [self toast:[error localizedDescription]];
        return;
    }
  
    [SMSInfo requestSMSWithPhone:self.telephoneText.text type:2 superView:self.view finshBlock:^(id obj, NSError *error) {
        self.timeCount = 60;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:sender repeats:YES];
    }];

}



-(void)reduceTime:(NSTimer *)codeTimer
{
    self.timeCount--;
    if (self.timeCount == 0) {
        [_optionVar setTitle:@"重新获取" forState:UIControlStateNormal];
        [_optionVar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *info = codeTimer.userInfo;
        info.enabled = YES;
        _optionVar.userInteractionEnabled = YES;
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%lu秒", (long)self.timeCount];
        [_optionVar setTitle:str forState:UIControlStateNormal];
        _optionVar.userInteractionEnabled = NO;
        
    }
}



- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{

    
    if (api ==_registerApi) {
        
        NSString *code = command.response.code;
        
        [Utils removeAllHudFromView:self.view];
        [Utils postMessage:command.response.msg onView:self.view];
      
        if ([code isEqualToString:@"0"]) {
          
            User *user = [User mj_objectWithKeyValues:_dic];
            user.token = self.token;
            NSLog(@"%d",[User LocalUser].ismobile);
            [User setLocalUser:user];
            [User LocalUser].ismobile =YES;
            [User saveToDisk];
            
#pragma mark- 在激光推送中为了将registerID设置在个人资料里，需要重新对用户信息进行设置
            [self.getInfoApi userInfoWithNikeName:[User LocalUser].nickname sex:[User LocalUser].sex face:[User LocalUser].face province:[User LocalUser].province city:[User LocalUser].city distrction:[User LocalUser].district registerId:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"]];
            
            [MobClick profileSignInWithPUID:[User LocalUser].uid];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
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
        [User LocalUser].registerId = responsObject[@"token"];       //推送的注册ID
        [User saveToDisk];
        
    }
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    if (api == _registerApi) {
        [User clearLocalUser];
        [Utils removeAllHudFromView:self.view];
        [Utils postMessage:[NSString stringWithFormat:@"%@,请直接去登录",command.response.msg] onView:self.view];
        
        if ([command.response.code isEqualToString:@"21"]) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    
                    
                } completion:^(BOOL finished) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                
            });
            
        }
     
    }
}

//绑定完成
- (IBAction)nextAction:(id)sender {

#pragma mark - 微信绑定完成
    
    [MobClick event:kEventWXLoginFinishBind];
    
#pragma mark- 微信绑定完成事件
    
     NSError *error = nil;
       BOOL p =  [ValidatorUtil isPassword:self.passwordText.text];
    
    if (self.smscodeText.text.length <= 0) {
        [self toast:@"输入验证码"];
        return;
        
    }
    if (![ValidatorUtil isValidPassword:self.passwordText.text error:&error]) {
        [self toast:[error localizedDescription]];
        return;
    }
    
    if (p) {
        
        [User LocalUser].token = self.token;
        
        [Utils addHudOnView:self.view];
         [self.registerApi getVerifyCodeWithPhone:self.telephoneText.text password:[self.passwordText.text MD5String] varCode:self.smscodeText.text];
    }else{
        [self toast:@"密码为6-16位数字和字母的组合"];
    
    }
    
}




- (IBAction)closePage:(id)sender {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
