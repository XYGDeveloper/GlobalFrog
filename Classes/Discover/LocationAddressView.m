//
//  LocationAddressView.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/6.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "LocationAddressView.h"

@implementation LocationAddressView

- (instancetype)initWithFrame:(CGRect)frame block:(ClickBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        clickBlock = block;
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        imgView.image = [UIImage imageNamed:@"orderDetail_address"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imgView];
        
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgView.width+5, 0, frame.size.width-imgView.width-5, imgView.height)];
        _addressLabel.font = [UIFont systemFontOfSize:15];
        _addressLabel.userInteractionEnabled = YES;
        [self addSubview:_addressLabel];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAddress)];
        [_addressLabel addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)clickAddress{
    clickBlock();
}

-(instancetype)initSearchWithFrame:(CGRect)frame block:(ClickBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        clickBlock = block;
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, self.height)];
        _addressLabel.text = @"深圳市▲";
        _addressLabel.font = [UIFont systemFontOfSize:15];
        _addressLabel.userInteractionEnabled = YES;
        [self addSubview:_addressLabel];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAddress)];
        [_addressLabel addGestureRecognizer:tap];
        
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(_addressLabel.width+10, 3, self.width-80, 30)];
        backView.backgroundColor = [UIColor orangeColor];
        [self addSubview:backView];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
