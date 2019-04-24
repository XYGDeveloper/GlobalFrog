//
//  QqwPersonalDataHeaderView.m
//  Qqw
//
//  Created by elink on 16/7/26.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "QqwPersonalDataHeaderView.h"

@interface QqwPersonalDataHeaderView ()
@property(nonatomic,strong)UIImageView* accountImage;
@property(nonatomic,strong)UILabel* accountLab;
@end

@implementation QqwPersonalDataHeaderView

-(UIImageView *)accountImage
{
    if (!_accountImage) {
        
        _accountImage=[[UIImageView alloc] init];
        _accountImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _accountImage.layer.borderWidth = 1.0f;
        _accountImage.layer.cornerRadius = 40.0f;
        _accountImage.layer.masksToBounds = YES;
        
        [self addSubview:_accountImage];
        [_accountImage mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).offset(20.0f);
            make.height.with.width.mas_equalTo(80.0f);
            
        }];
    }
    
    return _accountImage;
}

-(UILabel *)accountLab
{
    if (!_accountLab) {
        
        _accountLab=[[UILabel alloc] init];
        _accountLab.font = [UIFont systemFontOfSize:15.0f];
        _accountLab.textAlignment = NSTextAlignmentLeft;
        _accountLab.textColor = [UIColor whiteColor];
        [self addSubview:_accountLab];
        [_accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.accountImage.mas_centerY);
            make.left.mas_equalTo(self.accountImage.mas_right).offset(20);
            make.width.mas_equalTo(150.0f);
            make.height.mas_equalTo(40.0f);
        }];
    }
    
    return _accountLab;
}

-(void)setAccount:(NSString *)account withAccountImage:(NSString *)url
{
    
    self.accountImage.backgroundColor = [UIColor lightTextColor];
    self.accountLab.text = account;
    
}

-(void)dealloc
{
    NSLog(@"%@销毁了",NSStringFromClass([self class]));
}



@end
