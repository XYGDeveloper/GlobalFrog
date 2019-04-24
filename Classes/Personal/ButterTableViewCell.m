//
//  ButterTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 16/9/18.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "ButterTableViewCell.h"

@implementation ButterTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //headimg
        self.headImg = [[UIImageView alloc]init];
        [self.contentView addSubview:_headImg];
        _headImg.image = [UIImage imageNamed:@"1-2"];
        //role
        self.roleName = [[UILabel alloc]init];
        [self.contentView addSubview:_roleName];
        self.roleName.textColor =HexColorA(0x323232,0.8);
        self.roleName.font = [UIFont systemFontOfSize:15.0f];
        self.roleInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_roleInfo];
        self.roleInfo.titleLabel.font =[UIFont systemFontOfSize:15.0f];
        [self.roleInfo setTitleColor:HexColorA(0x323232,0.8) forState:UIControlStateNormal];
        self.roleInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
       
    }

    return self;
}



- (void)layoutSubviews
{

    [super layoutSubviews];
    
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(18.5f);
        make.width.height.mas_equalTo(20);
    
    }];
    
    [self.roleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(_headImg.mas_right).mas_equalTo(16.5f);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
        
    }];
    
    
    [self.roleInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.roleName.mas_right).mas_equalTo(0);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(30);
        
    }];
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
