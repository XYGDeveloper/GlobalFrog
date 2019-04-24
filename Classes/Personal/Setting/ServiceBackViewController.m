//
//  ServiceBackViewController.m
//  Qqw
//
//  Created by XYG on 16/8/13.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "ServiceBackViewController.h"
#import "HClTextView.h"
#import "SZTextView.h"
#import "DistributeViewController.h"
@interface ServiceBackViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UITextField *titleText;
@property (nonatomic,strong)UILabel *labelContent;
//@property (weak, nonatomic) HClTextView *textView;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UIButton *telephone;
@property (nonatomic,strong)NSString *contentStr;
@property (nonatomic,strong)SZTextView *textview;

@end

@implementation ServiceBackViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.textview.placeholder = @"全球蛙需要你的反馈和支持";
    self.textview.textColor = HexColorA(0x323232,0.8);
    self.textview.font = [UIFont systemFontOfSize:16.0f];
}


- (void)initWithViewController
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

//条评价内容
- (void)commit{
    [self.view endEditing:YES];

    [UserRequestApi requestFeedBackWithContent:_textview.text superView:self.view finshBlock:^(id obj, NSError *error) {
         [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textview  = [[SZTextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_textview];
    self.view.backgroundColor = [UIColor whiteColor];
    _textview.layer.borderColor = [UIColor colorWithWhite:0.734 alpha:1.000].CGColor;
    _textview.layer.borderWidth = 0.5;
    _textview.layer.cornerRadius = 4;
    [_textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.mas_equalTo(15);
        make.height.equalTo(@(200));
        make.width.mas_equalTo(kScreenWidth-20);
        
    }];
    [self setRightNavigationItemWithTitle:@"提交" action:@selector(commit)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
