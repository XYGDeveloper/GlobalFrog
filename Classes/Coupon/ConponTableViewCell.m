//
//  ConponTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/15.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "ConponTableViewCell.h"

@implementation ConponTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _bgView = [[UIImageView alloc]init];
        [self.contentView addSubview:_bgView];
        
        
        
        //优惠券名
        _componName = [[UILabel alloc]init];
        [self.bgView addSubview:_componName];
        
        _componName.textColor = [UIColor whiteColor];
        _componName.font = [UIFont systemFontOfSize:20.0f];
        _componName.adjustsFontSizeToFitWidth = YES;
        //优惠券副标题
        
        _componDetailName = [[UILabel alloc]init];
        [self.bgView addSubview:_componDetailName];
        _componDetailName.textColor = [UIColor whiteColor];
        _componDetailName.font = [UIFont systemFontOfSize:14.0f];
        
        //有效期
        _deadLine = [[UILabel alloc]init];
        [_bgView addSubview:_deadLine];
        _deadLine.adjustsFontSizeToFitWidth = YES;
        _deadLine.textColor = [UIColor whiteColor];
        _deadLine.font = [UIFont systemFontOfSize:14.0f];
        //优惠券类型
        
        _typeLabel = [[UILabel alloc]init];
        [_bgView addSubview:_typeLabel];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:14.0f];
        
        //立即使用
        
        _useAction = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:_useAction];
        _useAction.titleLabel.font =[UIFont systemFontOfSize:13.0f];
        _useAction.layer.cornerRadius=2;
        _useAction.layer.masksToBounds = YES;
        [_useAction setTitle:@"立即使用" forState:UIControlStateNormal];
        
        [_useAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _useAction.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
        
        
    }
    
    
    return self;
    
    
    
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    [_useAction mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@-75);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).mas_equalTo(-5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(25);
        
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(0);
 
    }];
    
    [_componName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).mas_equalTo(0);
        make.left.mas_equalTo(self.bgView.mas_left).mas_equalTo(10);
        make.right.equalTo(@-70);
        make.height.mas_equalTo(40);
        
    }];
    
    [_componDetailName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_componName.mas_bottom).mas_equalTo(7);
        make.left.mas_equalTo(self.bgView.mas_left).mas_equalTo(10);
        make.width.equalTo(_componName.mas_width);
        make.height.mas_equalTo(20);
        
    }];
    [_deadLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom).mas_equalTo(-10);
        make.left.mas_equalTo(self.bgView.mas_left).mas_equalTo(10);
        make.right.equalTo(_useAction.mas_left).offset(-5);
        make.height.mas_equalTo(20);
        
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.bgView.mas_top).mas_equalTo(10);
        make.right.mas_equalTo(self.bgView.mas_right).mas_equalTo(-5);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
        
    }];
    
    
}

-(void)setDataWithType:(CouponType)type conponModel:(ConponModel*)model{
    _model = model;
    _componName.text = model.title;
    _componDetailName.text = model.instr;
    _deadLine.text = model.time_text;
    
    switch (type) {
        case CouponType_Unused:
            _bgView.image = [UIImage imageNamed:@"coppon"];
            [_useAction setTitle:@"立即使用" forState:UIControlStateNormal];

            break;
        case CouponType_Used:
            _bgView.image = [UIImage imageNamed:@"conpon_update"];
            [_useAction setTitle:@"已使用" forState:UIControlStateNormal];

            break;
        case CouponType_expired:
            _bgView.image = [UIImage imageNamed:@"conpon_update"];
            [_useAction setTitle:@"已失效" forState:UIControlStateNormal];


            break;
            
        default:
            break;
    }
}




- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
