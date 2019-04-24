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
        self.img.layer.cornerRadius = 30;
        self.img.layer.masksToBounds = YES;
        [self.contentView addSubview:_img];
        
        self.titleLabel = [UILabel new];
        [self.titleLabel sizeToFit];
        self.titleLabel.textColor = HexColor(0x323232);
        [self.contentView addSubview:_titleLabel];
        
        self.subTitleLabel = [UILabel new];
        [self.subTitleLabel sizeToFit];
        self.subTitleLabel.textColor = HexColor(0x666666);
        [self.contentView addSubview:_subTitleLabel];
        self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.attentionButton.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_attentionButton];
        [self.attentionButton addTarget:self action:@selector(addToAttentionAction:) forControlEvents:UIControlEventTouchUpInside];
        self.attentionButton.layer.cornerRadius = 4;
        self.attentionButton.layer.borderWidth = 1;
        self.line = [[UIImageView alloc]init];
        self.line.backgroundColor  = HexColor(0xd6d7dc);
        [self.contentView addSubview:_line];
        
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
        make.width.height.mas_equalTo(60);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
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
        
        make.right.mas_equalTo(self.contentView.right).mas_equalTo(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(32);
        
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-3);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setModel:(AttentionModel *)model{
    _model = model;
    [_img sd_setImageWithURL:[NSURL URLWithString:model.face] placeholderImage:[UIImage imageNamed:@""]];
    _titleLabel.text = model.nickname;
    _subTitleLabel.text = model.directions;
    
}

- (void)addToAttentionAction:(UIButton *)button
{
    if (self.addAttention) {
        
        self.addAttention(self.model);
                
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
