//
//  MyInfoViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "KeyboardInputView.h"

@implementation KeyboardInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.textField = [[UITextField alloc] init];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.placeholder = @"说点什么...";
        [self addSubview:self.textField];
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(5);
            make.width.mas_equalTo(frame.size.width - 60- 5);
            make.height.mas_equalTo(frame.size.height-10);
        }];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitle:@"发送" forState:UIControlStateNormal];
        [self.button setTitleColor:AppStyleColor forState:UIControlStateNormal];
        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(self.textField.mas_right);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(frame.size.height);
            
        }];
        self.textField.enablesReturnKeyAutomatically = YES;
        [self.button setEnabled:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
    }
    return self;
}
-(void)textFieldChanged :(NSNotification *)noty{
    UITextField * t = noty.object;
    if (t.text.length<1) {
        [self.button setEnabled:NO];
    }else{
        [self.button setEnabled:YES];
    }
    NSLog( @"text changed: %@", t.text);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
