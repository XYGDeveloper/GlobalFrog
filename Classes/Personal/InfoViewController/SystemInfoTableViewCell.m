//
//  SystemInfoTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/14.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "SystemInfoTableViewCell.h"
#import "UIView+WHC_AutoLayout.h"
@implementation SystemInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.content = [[UILabel alloc]init];
        self.content.userInteractionEnabled = YES;
        self.content.numberOfLines = 0;
        self.content.textAlignment = NSTextAlignmentLeft;
        self.content.textColor = HexColor(0x323232);
        [self.contentView addSubview:_content];
        
        self.time = [[UILabel alloc]init];
        self.time.userInteractionEnabled = YES;

        self.time.textAlignment = NSTextAlignmentRight;
        self.time.textColor = HexColor(0x909090);
        self.time.font = Font(12);
        [self.contentView addSubview:_time];
        self.img = [[UIImageView alloc]init];
        self.img.backgroundColor = HexColor(0xd63d3e);
        self.img.userInteractionEnabled = YES;
        self.img.layer.cornerRadius = 2.5;
        [self.contentView addSubview:_img];
        
    }

    return  self;
    

}



- (void)layoutSubviews
{

    [super layoutSubviews];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(kScreenWidth - 100);
        make.left.mas_equalTo(5);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(-5);
        make.left.mas_equalTo(self.content.mas_right).mas_equalTo(5);
        make.height.mas_equalTo(30);
        
    }];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.time.mas_bottom).mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.width.height.mas_equalTo(5);
        
    }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
