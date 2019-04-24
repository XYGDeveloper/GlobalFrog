//
//  systemMessageDetailViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/17.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "systemMessageDetailViewController.h"

@interface systemMessageDetailViewController ()

@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *contentLabel;

@end

@implementation systemMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.layer.cornerRadius = 6;
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.backgroundColor = HexColor(0xcdcdcd);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.timeLabel sizeToFit];
    self.timeLabel.text = self.dateline;
    [self.view addSubview:_timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(120);
    }];

    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = self.content;
    self.contentLabel.numberOfLines = 0;
    CGFloat h = [Utils getSpaceLabelHeight:_contentLabel.text withWidth:kScreenWidth-20];
    [self.view addSubview:_contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(kScreenWidth - 20);
        make.height.mas_equalTo(h);
        make.left.mas_equalTo(10);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}
#pragma Mark 计算富文本的宽度
- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.height;
}


@end
