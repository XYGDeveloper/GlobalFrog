//
//  ForgetViewController.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "ForgetViewController.h"
#import "NewPasswordViewController.h"
#import <MBProgressHUD.h>
#import "ValidatorUtil.h"
#import "SMSInfo.h"

@interface ForgetViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIButton *telephone;

@property (weak, nonatomic) IBOutlet UITextField *telephoneText;
@property (weak, nonatomic) IBOutlet UIButton *varcode;
@property (weak, nonatomic) IBOutlet UITextField *varText;

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)NSInteger timeCount;

@property (weak, nonatomic) IBOutlet UIButton *optionButton;



@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.telephoneText.delegate = self;
    self.varText.delegate = self;
    
    self.navigationController.navigationBarHidden = NO;
    self.nextButton.alpha = 0.4;
    self.nextButton.enabled = NO;
    self.nextButton.layer.cornerRadius =20;
    self.telephoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.telephoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.varText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.varText.keyboardType = UIKeyboardTypeNumberPad;
    [self.telephoneText  addTarget:self action:@selector(teleFieldChange:)forControlEvents:UIControlEventEditingChanged];
    [self.varText  addTarget:self action:@selector(varTextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    
    self.optionButton.alpha = 0.6;
    self.optionButton.enabled = NO;
    
    
    // Do any additional setup after loading the view from its nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;

}


-(void)teleFieldChange:(id)sender{
    if (self.telephoneText.text.length==11) {
        //  1. 登录按钮变为可点击状态
        self.telephone.selected = YES;
        self.optionButton.enabled = YES;
        self.optionButton.alpha = 1;
        self.optionButton.backgroundColor = HexColor(0x53A020);
    }else{
        self.telephone.selected = NO;
        self.optionButton.enabled = NO;
        self.optionButton.backgroundColor = HexColor(0xCCCCCC);
    }
    
}

-(void)varTextFieldChange:(id)sender{
    if (self.varText.text.length >0) {
        //  1. 登录按钮变为可点击状态
        self.varcode.selected = YES;
        self.nextButton.alpha = 1;
        self.nextButton.enabled = YES;
        
    }else
    {
        self.varcode.selected = NO;
        self.nextButton.alpha = 0.4;
        self.nextButton.enabled = NO;
        
    }
}

-(void)toast:(NSString *)title{
    [Utils showErrorMsg:self.view type:0 msg:title];
}


//获取忘记密码验证码
- (IBAction)optionVarAction:(id)sender {
    [self.view endEditing:YES];
    NSError *error = nil;
    if (![ValidatorUtil isValidMobile:self.telephoneText.text error:&error]) {
        [self toast:[error localizedDescription]];
        return;
    }
    
    [SMSInfo requestSMSWithPhone:self.telephoneText.text type:3 superView:self.view finshBlock:^(id obj, NSError *error) {
        self.timeCount = 60;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:sender repeats:YES];
    }];
 
}

-(void)reduceTime:(NSTimer *)codeTimer{
    self.timeCount--;
    if (self.timeCount == 0) {
        [_optionButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [_optionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *info = codeTimer.userInfo;
        info.enabled = YES;
        _optionButton.userInteractionEnabled = YES;
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%lu秒", (long)self.timeCount];
        [_optionButton setTitle:str forState:UIControlStateNormal];
        _optionButton.userInteractionEnabled = NO;
        
    }
}

- (IBAction)setPassword:(id)sender {
    [self.view endEditing:YES];
    [SMSInfo requestCheckCodeWithPhone:self.telephoneText.text smscode:self.varText.text superView:self.view finshBlock:^(id obj, NSError *error) {
        NewPasswordViewController *newPassword = [[NewPasswordViewController alloc]init];
        newPassword.telephone = self.telephoneText.text;
        newPassword.smsCode = self.varText.text;
        [self.navigationController pushViewController:newPassword animated:YES];
    }];
}

@end


