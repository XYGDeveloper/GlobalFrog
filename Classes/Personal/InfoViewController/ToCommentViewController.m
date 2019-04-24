//
//  ToCommentViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/16.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "ToCommentViewController.h"
#import "SZTextView.h"
#import "ToCommentApi.h"
@interface ToCommentViewController ()<ApiRequestDelegate>
@property (nonatomic,strong)SZTextView *textview;
@property (nonatomic,strong)ToCommentApi *api;


@end

@implementation ToCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightNavigationItemWithTitle:@"提交" action:@selector(commitComment)];
    _textview  = [[SZTextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_textview];
    self.view.backgroundColor = DefaultBackgroundColor;
    _textview.layer.borderColor = [UIColor colorWithWhite:0.734 alpha:1.000].CGColor;
    _textview.layer.borderWidth = 1;
    _textview.layer.cornerRadius = 4;
    [_textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.mas_equalTo(0);
        make.height.equalTo(@(200));
        make.width.mas_equalTo(kScreenWidth-20);
        
    }];

    self.textview.placeholder = @"我觉得这个很赞！";
    self.textview.textColor = HexColorA(0x323232,0.8);
    self.textview.font = [UIFont systemFontOfSize:16.0f];
    // Do any additional setup after loading the view.
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


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    
    [textView resignFirstResponder];
    return YES;
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [Utils removeAllHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
    
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    [Utils removeAllHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)commitComment
{

    [Utils addHudOnView:self.view];
    _api = [[ToCommentApi alloc]init];
    _api.delegate = self;
    
    NSLog(@"%@,%@",self.arctile_id,self.textview.text);
    [_api toCommitCommentWithId:self.arctile_id contentStr:_textview.text];
    
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
