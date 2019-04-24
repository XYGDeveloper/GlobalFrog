//
//  ModifyPasswordViewController.m
//  Qqw
//
//  Created by 全球蛙 on 16/9/5.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import <MBProgressHUD.h>
#import "ValidatorUtil.h"
#import "User.h"
#import "ForgetViewController.h"
@interface ModifyPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *orPassword;
@property (weak, nonatomic) IBOutlet UIButton *rePassword;

@property (weak, nonatomic) IBOutlet UIButton *surePassword;

@property (weak, nonatomic) IBOutlet UITextField *oriPasswordText;

@property (weak, nonatomic) IBOutlet UITextField *resetPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordText;

@property (weak, nonatomic) IBOutlet UIButton *commitbutton;


@property (weak, nonatomic) IBOutlet UIButton *ForgettonExt;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //delegate
    [self.ForgettonExt setTitleColor:HexColor(0x323232) forState:UIControlStateNormal];
    self.oriPasswordText.delegate = self;
    self.resetPasswordText.delegate = self;
    self.surePasswordText.delegate  =self;
    //securty
    self.oriPasswordText.secureTextEntry = YES;
    self.resetPasswordText.secureTextEntry = YES;
    self.surePasswordText.secureTextEntry  =YES;
    //clearButtonMode
    self.oriPasswordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.resetPasswordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.surePasswordText.clearButtonMode  =UITextFieldViewModeWhileEditing;
    
    //button Ddfauit setting
    self.commitbutton.alpha = 0.4;
    self.commitbutton.enabled = NO;
    self.commitbutton.layer.cornerRadius = 20;
    self.commitbutton.layer.masksToBounds  = YES;
    
    //check Password Mode
    [self.oriPasswordText  addTarget:self action:@selector(oripasswordTextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    [self.resetPasswordText  addTarget:self action:@selector(resetpasswordTextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    [self.surePasswordText  addTarget:self action:@selector(surepasswordTextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    
    
    
}

//键盘响应事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;

    
}

-(void)oripasswordTextFieldChange:(id)sender{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self.oriPasswordText.text dataUsingEncoding:enc];
   
    if (da.length > 5 &&da.length <= 16) {
        //  1. 登录按钮变为可点击状态
        self.orPassword.selected = YES;
        
    }else{
        
        self.orPassword.selected = NO;

    }

}

-(void)resetpasswordTextFieldChange:(id)sender{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self.resetPasswordText.text dataUsingEncoding:enc];
    if (da.length > 5 &&da.length <= 16) {
        //  1. 登录按钮变为可点击状态
        self.rePassword.selected = YES;
        
    }else{
        self.rePassword.selected = NO;
        
    }
}


- (void)surepasswordTextFieldChange:(id)sender{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self.surePasswordText.text dataUsingEncoding:enc];
    if (da.length > 5 &&da.length <= 16) {
        //  1. 登录按钮变为可点击状态
        self.surePassword.selected = YES;
        //提交按钮的正常状态
        self.commitbutton.alpha = 1;
        self.commitbutton.enabled = YES;
        
    }else{
        self.surePassword.selected = NO;
        //提交按钮的非正常状态
        self.commitbutton.alpha = 0.4;
        self.commitbutton.enabled = NO;
        
    }
}

-(void)toast:(NSString *)title{
    [Utils showErrorMsg:self.view type:0 msg:title];
}

-(void)toastWithError:(NSError *)error
{
    NSString *errorStr = [NSString stringWithFormat:@"网络出错：%@，code：%ld", error.domain, (long)error.code];
    [self toast:errorStr];
}


- (IBAction)commitAction:(id)sender {
    
    [self.view endEditing:YES];
    
    BOOL p =  [ValidatorUtil isPassword:self.oriPasswordText.text];
    BOOL p1 =  [ValidatorUtil isPassword:self.resetPasswordText.text];
    BOOL p2 =  [ValidatorUtil isPassword:self.surePasswordText.text];

    if (!p || self.oriPasswordText.text.length < 6) {
          [self toast:@"原密码为6-16位数字和字母的组合"];
        
        return;
        
    }else if (!p1 || self.resetPasswordText.text.length < 6) {
          [self toast:@"新设置密码为6-16位数字和字母的组合"];
        return;
        
    }else if (!p2 || self.surePasswordText.text.length < 6) {
          [self toast:@"确认密码为6-16位数字和字母的组合"];
        return;
        
    } else if (p== YES &&p1== YES && p2 == YES) {
        
        if (![self.resetPasswordText.text isEqualToString:self.surePasswordText.text]) {
            [Utils showErrorMsg:self.view type:0 msg:@"两次输入地密码不一致"];
            return;
        }
        [Utils addHudOnView:self.view];
        [SMSInfo requestChangePwdWithOldPassword:[self.oriPasswordText.text MD5String] newPassword:[self.resetPasswordText.text MD5String] surePassword:[self.surePasswordText.text MD5String] type:0 superView:self.view finshBlock:^(id obj, NSError *error) {
            [User clearLocalUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccessNotify object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kModifyPasswordSuccessNotify object:nil];
        }];

    }
    
}


- (IBAction)jumpToForget:(id)sender {
    
    ForgetViewController *forgetton = [ForgetViewController new];
    forgetton.title = @"忘记密码";
    [self.navigationController pushViewController:forgetton animated:YES];
    forgetton.hidesBottomBarWhenPushed = YES;
    
}








@end
