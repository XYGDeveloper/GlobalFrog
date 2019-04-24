//
//  UsingTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "UsingTableViewCell.h"

@implementation UsingTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _bgView = [[UIImageView alloc]init];
        [self.contentView addSubview:_bgView];
        _bgView.image = [UIImage imageNamed:@"coppon"];
        
        _useAction = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:_useAction];
        [_useAction setFont:[UIFont systemFontOfSize:13.0f]];
        
        [_useAction setTitle:@"使用" forState:UIControlStateNormal];
        
        [_useAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _useAction.backgroundColor = [UIColor colorWithRed:0.790 green:0.397 blue:0.000 alpha:1.000];
        
        
    }
    return self;
    
    
    
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    [_useAction mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.bgView.mas_right).mas_equalTo(-5);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).mas_equalTo(-5);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
        
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(0);
        
        
    }];
    
    
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
