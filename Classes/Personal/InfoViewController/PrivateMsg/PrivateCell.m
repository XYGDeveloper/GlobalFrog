//
//  PrivateCell.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/16.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "PrivateCell.h"

@implementation PrivateCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _faceImg = [[UIImageView alloc] init];
        _faceImg.clipsToBounds = YES;
        _faceImg.contentMode = UIViewContentModeScaleAspectFill;
        _faceImg.layer.cornerRadius = 10;
        _faceImg.layer.masksToBounds = YES;
        [self.contentView addSubview:self.faceImg];
        _nickNameLab = [[UILabel alloc] init];
        _nickNameLab = GeneralLabelA(Font(15), TextColor1, NSTextAlignmentCenter);
        _privateMsgLab = [[UILabel alloc] init];
        _privateMsgLab = GeneralLabelA(Font(13), TextColor3, NSTextAlignmentCenter);
        [self.contentView addSubview:self.nickNameLab];
        _dateLab = [[UILabel alloc] init];
        _dateLab = GeneralLabelA(Font(11), TextColor3, NSTextAlignmentCenter);
        _cutLine = [[UIImageView alloc] init];
        _cutLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.privateMsgLab];
        [self.contentView addSubview:self.dateLab];
        [self.contentView addSubview:self.cutLine];
    }
    return self;

}


- (void)layoutSubviews
{

    [super layoutSubviews];
    
    [self.faceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@34);
        make.top.left.equalTo(self.contentView).with.offset(10);
    }];
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(14);
        make.left.equalTo(self.faceImg).with.offset(17.5);
    }];
    [self.privateMsgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.faceImg).with.offset(17.5);
        make.top.equalTo(self.nickNameLab).with.offset(5);
    }];
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-10);
        make.centerY.mas_equalTo(self.nickNameLab);
    }];
    [self.cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@314);
        make.height.equalTo(@0.5);
        make.right.equalTo(self.contentView).width.offset(0);
        make.height.equalTo(@63);
        
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
