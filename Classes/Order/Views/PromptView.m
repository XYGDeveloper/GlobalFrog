//
//  PromptView.m
//  Qqw
//
//  Created by 全球蛙 on 2017/2/28.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "PromptView.h"

@implementation PromptView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        bkView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        bkView.alpha = 0.4;
        bkView.backgroundColor = [UIColor blackColor];
        [self addSubview:bkView];
        
        bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 115)];
        bjView.backgroundColor = [UIColor whiteColor];
        bjView.center = CGPointMake(bkView.width/2, bkView.height/2);
        [self addSubview:bjView];
        
        msglabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bjView.width, 73)];
        msglabel.backgroundColor = [UIColor clearColor];
        msglabel.font = [UIFont systemFontOfSize:15];
        msglabel.numberOfLines = 0;
        msglabel.textAlignment = NSTextAlignmentCenter;
        [bjView addSubview:msglabel];
        
        UIButton * b = [UIButton buttonWithType:(UIButtonTypeSystem)];
        b.tintColor = [UIColor rgb:@"5cb531"];
        [b setTitle:@"确认" forState:NO];
        b.frame = CGRectMake(0, msglabel.height, bjView.width, 42);
        [b addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [bjView addSubview:b];
        
        UIView * linView = [[UIView alloc]initWithFrame:CGRectMake(0, msglabel.height, bjView.width, 0.5)];
        linView.backgroundColor = [UIColor rgb:@"e6e6e6"];
        [bjView addSubview:linView];
        
        
    }
    return self;
}

-(void)showWithMsg:(NSString *)msg{
    msglabel.text = msg;
    [[AppDelegate APP].window addSubview:self];

}

-(void)dismiss{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
