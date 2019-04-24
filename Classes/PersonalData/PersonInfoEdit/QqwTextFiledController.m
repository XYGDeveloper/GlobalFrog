//
//  QqwTextFiledController.m
//  Qqw
//
//  Created by elink on 16/7/28.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "QqwTextFiledController.h"

@interface QqwTextFiledController ()
@property(nonatomic,copy)textFiledResultBlock result;
@property(nonatomic,strong)NSString* customTitle;
@property(nonatomic,strong)UITextField* myTextFiled;
@property(nonatomic,strong)NSString* content;
@end

@implementation QqwTextFiledController

-(id)initWithTitle:(NSString*)title textContent:(NSString*)content TextFiledResult:(textFiledResultBlock)result
{
    
    
    if (self=[super init]) {
        
        self.customTitle = title;
        
        self.result = result;
        
        self.content = content;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initView];
}

-(void)initView
{
    self.title = self.customTitle;
    self.view.backgroundColor = RGB(238.0f,238.0f,243.0f);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.myTextFiled = [[UITextField alloc] init];
    self.myTextFiled.text = self.content;
    self.myTextFiled.textColor = HexColorA(0x323232,0.8);
    self.myTextFiled.font = [UIFont systemFontOfSize:15.0f];
    self.myTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.myTextFiled.backgroundColor = [UIColor whiteColor];
    self.myTextFiled.leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0,10.0f,50.0f)];
    self.myTextFiled.leftViewMode =UITextFieldViewModeAlways;
    [self.myTextFiled becomeFirstResponder];
    [self.view addSubview:self.myTextFiled];
    [self.myTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(50.0f);
    }];
    
    UIButton* rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f,0.0f,80.0f,40.0f)];
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0,35,0,-15);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    rightBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

- (BOOL)JudgeTheillegalCharacter:(NSString *)content{
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}

//-(void)toast:(NSString *)title seconds:(int)seconds
//{
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.detailsLabelText = title;
//    HUD.mode = MBProgressHUDModeText;
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        sleep(seconds);
//    } completionBlock:^{
//        
//        [HUD removeFromSuperview];
//        
//    }];
//}

-(void)toast:(NSString *)title
{
    //    int seconds = 3;
    //    [self toast:title seconds:seconds];
    [Utils showErrorMsg:self.view type:0 msg:title];
}

-(void)saveAction
{
    
    
    
    if ([self JudgeTheillegalCharacter:self.myTextFiled.text]) {
        [self toast:@"昵称不能为空格或其他特殊字符"];
    }else
    {
    
        NSUserDefaults *usersss = [NSUserDefaults standardUserDefaults];
        [usersss setObject:self.myTextFiled.text forKey:@"nike"];
        [usersss synchronize];
        if (self.result) {
            self.result(self.myTextFiled.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
}


-(void)dealloc
{

    NSLog(@"%@销毁了",NSStringFromClass([self class]));
  
}





@end
