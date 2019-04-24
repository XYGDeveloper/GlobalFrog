//
//  UsendTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "UsendTableViewCell.h"

@implementation UsendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _bgView = [[UIImageView alloc]init];
        [self.contentView addSubview:_bgView];
        _bgView.image = [UIImage imageNamed:@"conpon_update"];
        
        _useAction = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:_useAction];
        [_useAction setFont:[UIFont systemFontOfSize:13.0f]];
        [_useAction setTitle:@"已过期" forState:UIControlStateNormal];
        [_useAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _useAction.backgroundColor = [UIColor grayColor];
        
        
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
