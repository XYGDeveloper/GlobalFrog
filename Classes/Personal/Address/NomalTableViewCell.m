//
//  NomalTableViewCell.m
//  Qqw
//
//  Created by XYG on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "NomalTableViewCell.h"

@implementation NomalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nikeName = [[UILabel alloc]init];
        [self.contentView addSubview:_nikeName];
        self.nikeName.textColor = [UIColor colorWithWhite:0.597 alpha:1.000];
        self.telephone = [[UILabel alloc]init];
        [self.contentView addSubview:_telephone];
        self.telephone.textAlignment = NSTextAlignmentRight;
        self.telephone.textColor = [UIColor colorWithWhite:0.597 alpha:1.000];
        self.address = [[UILabel alloc]init];
        [self.contentView addSubview:_address];
        self.address.textColor = [UIColor colorWithWhite:0.597 alpha:1.000];
        self.faultAddress = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.faultAddress setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.contentView addSubview:_faultAddress];
        self.label = [[UILabel alloc]init];
        [self.contentView addSubview:_label];
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_editButton];
         [self.editButton setBackgroundImage:[UIImage imageNamed:@"center"] forState:UIControlStateNormal];
        
    }
    return self;
    
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    [self.nikeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(20);
        
    }];
    [self.telephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(_nikeName.mas_right).mas_equalTo(0);;
        make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(-10);
        make.height.mas_equalTo(20);
        
    }];
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nikeName.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(-10);
        make.height.mas_equalTo(20);
        
    }];
    [self.faultAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_address.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(20);
        
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_address.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(_faultAddress.mas_right).mas_equalTo(3);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
        
    }];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_address.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(-10);
        make.width.height.mas_equalTo(20);
        
    }];
    
}




- (void)setModel:(AddressModel *)model
{
    
    _model = model;
    
    
    
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
