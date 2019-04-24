//
//  NewPasswordViewController.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "TelephoneVarViewController.h"
#import <MBProgressHUD.h>
#import "ValidatorUtil.h"
#import "LoginViewControll.h"
@interface NewPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *finishReset;

@property (weak, nonatomic) IBOutlet UIButton *oriPassword;

@property (weak, nonatomic) IBOutlet UITextField *oriPasswordText;

@property (weak, nonatomic) IBOutlet UIButton *resetPassword;

@property (weak, nonatomic) IBOutlet UITextField *resetPasswordText;



@end

@implementation NewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    self.finishReset.layer.cornerRadius = 20;
    self.oriPasswordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.resetPasswordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.oriPasswordText.secureTextEntry = YES;
    self.resetPasswordText.secureTextEntry  = YES;
    self.oriPasswordText.delegate = self;
    self.resetPasswordText.delegate = self;
    
    [self.oriPasswordText  addTarget:self action:@selector(oriFieldChange:)forControlEvents:UIControlEventEditingChanged];
    [self.resetPasswordText  addTarget:self action:@selector(resetTextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)oriFieldChange:(id)sender{

    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self.oriPasswordText.text dataUsingEncoding:enc];
   
    if (da.length > 5 &&da.length <= 16) {
        //  1. 登录按钮变为可点击状态
        self.oriPassword.selected = YES;
        
    }else{
        self.oriPassword.selected = NO;
        
    }
    
}

-(void)resetTextFieldChange:(id)sender{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self.resetPasswordText.text dataUsingEncoding:enc];
    if (da.length > 5 &&da.length <= 16) {
        //  1. 登录按钮变为可点击状态
        self.resetPassword.selected = YES;
        self.resetPassword.alpha = 1;
        self.resetPassword.enabled = YES;
    }else{
        self.resetPassword.selected = NO;
        self.resetPassword.alpha = 0.4;
        self.resetPassword.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)toast:(NSString *)title{
    [Utils showErrorMsg:self.view type:0 msg:title];
}

//完成密码重置
- (IBAction)finishResetPasswordAction:(id)sender {
    [self.view endEditing:YES];
    BOOL p =  [ValidatorUtil isPassword:self.oriPasswordText.text];
    
    if (!p) {
        [self toast:@"密码为6-16位数字和字母的组合"];
    }
    
    if (![self.oriPasswordText.text isEqualToString:self.resetPasswordText.text]) {
        [self toast:@"两次输入的密码不一致"];
        return;
    }
    [SMSInfo requestRestPwdWithPhone:self.telephone smscode:self.smsCode password:[self.resetPasswordText.text MD5String] superView:self.view finshBlock:^(id obj, NSError *error) {
        if ([User hasLogin]== YES) {
            [User clearLocalUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccessNotify object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kModifyPasswordSuccessNotify object:nil];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
