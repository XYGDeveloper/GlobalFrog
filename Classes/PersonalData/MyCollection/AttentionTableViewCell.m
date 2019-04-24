//
//  AttentionTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "AttentionTableViewCell.h"

@implementation AttentionTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.img = [UIImageView new];
        self.img.layer.cornerRadius = 39;
        self.img.layer.masksToBounds = YES;
        self.img.image = [UIImage imageNamed:@"share_wechatTimeline"];
        [self.contentView addSubview:_img];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.text = @"手作杂货铺";
        [self.titleLabel sizeToFit];
        [self.contentView addSubview:_titleLabel];
        
        self.subTitleLabel = [UILabel new];
        self.subTitleLabel.text = @"推荐好商品，卖包全球";
        [self.subTitleLabel sizeToFit];
        [self.contentView addSubview:_subTitleLabel];
        self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.attentionButton.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_attentionButton];
        [self.attentionButton addTarget:self action:@selector(addToAttentionAction:) forControlEvents:UIControlEventTouchUpInside];
        self.attentionButton.layer.cornerRadius = 2;
        self.attentionButton.layer.borderWidth = 2;
        
        //做一个简单的判断
        //更新同步状态(接口返回)
        //..........
        
        [self.attentionButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:HexColor(0x5cb531) forState:UIControlStateNormal];
//        self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:.0f];
        [self.attentionButton.titleLabel sizeToFit];
        self.attentionButton.layer.borderColor = HexColor(0x5cb531).CGColor;
        
    }
    
    return  self;


}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(78);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(34);
        make.left.mas_equalTo(self.img.mas_right).mas_equalTo(12);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(0);
        make.left.mas_equalTo(self.img.mas_right).mas_equalTo(12);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    [self.attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.contentView.right).mas_equalTo(-20);
        make.top.mas_equalTo(40);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(42);
        
    }];
    
}


- (void)addToAttentionAction:(UIButton *)button
{
    if (self.addAttention) {
        
        self.addAttention(self.model);
        
    }
    
}

- (void)setModel:(AttentionModel *)model
{
    self.model = model;
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
