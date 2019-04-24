//
//  QqwSexRadioCell.m
//  Qqw
//
//  Created by elink on 16/7/28.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "QqwSexRadioCell.h"
#import "User.h"
@interface QqwSexRadioCell ()
@property(nonatomic,strong)UILabel* sexTitleLab;
@property(nonatomic,strong)UIButton* maleBtn;
@property(nonatomic,strong)UIButton* femaleBtn;
@property(nonatomic,assign)sex selecteSex;
@property(nonatomic,copy)SexSelectedBlock result;
@end
@implementation QqwSexRadioCell

-(UILabel *)sexTitleLab
{
    if (!_sexTitleLab)
    {
        _sexTitleLab = [[UILabel alloc] init];
        _sexTitleLab.text = @"性别";
        _sexTitleLab.font = [UIFont systemFontOfSize:15.0f];
        _sexTitleLab.textAlignment = NSTextAlignmentLeft;
        _sexTitleLab.textColor = HexColorA(0x323232,0.8);
        [self.contentView addSubview:_sexTitleLab];
        [_sexTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(20.0f);
            make.width.mas_equalTo(80.0f);
            make.height.mas_equalTo(self.mas_height);
        }];
    }
    return _sexTitleLab;
}

-(UIButton *)maleBtn
{
    if (!_maleBtn) {
        
        _maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _maleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _maleBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_maleBtn setImage:[UIImage imageNamed:@"cart_unselect"] forState:UIControlStateNormal];
        [_maleBtn setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
        [_maleBtn setTitle:@"男" forState:UIControlStateNormal];
        [_maleBtn setTitleColor:HexColorA(0x323232,0.8) forState:UIControlStateNormal];
        [_maleBtn setImageEdgeInsets:UIEdgeInsetsMake(12.5f,0.0f,12.5f,25.0f)];
        [_maleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f,0.0f,0.0f,0.0f)];
        [_maleBtn addTarget:self action:@selector(sexChoseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_maleBtn];
        
        
        if ([[User LocalUser].sex isEqualToString:@"0"]) {
            self.femaleBtn.selected = NO;
            self.maleBtn.selected = YES;
            self.selecteSex = male;
            
            
        } else if ([[User LocalUser].sex isEqualToString:@"1"]){
            self.maleBtn.selected = NO;
            self.femaleBtn.selected = YES;
            self.selecteSex = female;
            
            
        }

        
        [_maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {

            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.sexTitleLab.mas_right);
            make.width.with.height.mas_equalTo(40.0f);
        }];
    }
    
    return _maleBtn;
}

-(UIButton *)femaleBtn
{
    if (!_femaleBtn) {
        
        _femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _femaleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _femaleBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_femaleBtn setImage:[UIImage imageNamed:@"cart_unselect"] forState:UIControlStateNormal];
        [_femaleBtn setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
        [_femaleBtn setTitle:@"女" forState:UIControlStateNormal];
        [_femaleBtn setTitleColor:HexColorA(0x323232,0.8) forState:UIControlStateNormal];
        [_femaleBtn setImageEdgeInsets:UIEdgeInsetsMake(12.5f,0.0f,12.5f,25.0f)];
        [_femaleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f,0.0f,0.0f,0.0f)];
        [_femaleBtn addTarget:self action:@selector(sexChoseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_femaleBtn];
        
        if ([[User LocalUser].sex isEqualToString:@"0"]) {
            self.femaleBtn.selected = NO;
            self.maleBtn.selected = YES;
            
        } else if ([[User LocalUser].sex isEqualToString:@"1"]){
            self.maleBtn.selected = NO;
            self.femaleBtn.selected = YES;
            self.selecteSex = female;
            
            
        }
        
        [_femaleBtn mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.maleBtn.mas_right).offset(10.0f);
            make.width.with.height.mas_equalTo(40.0f);
        }];

        
    }
    
    return _femaleBtn;
}

-(void)sexChoseAction:(UIButton*)btn
{
    if ([btn isEqual:self.maleBtn]&&self.selecteSex!=male) {
        
        self.femaleBtn.selected = NO;
        self.maleBtn.selected = YES;
        self.selecteSex = male;
        
        if (self.result) {
            
            self.result(self.selecteSex);
        }
        
    }else if ([btn isEqual:self.femaleBtn]&&self.selecteSex!=female)
    {
        self.maleBtn.selected = NO;
        self.femaleBtn.selected = YES;
        self.selecteSex = female;
        
        if (self.result) {
            
            self.result(self.selecteSex);
        }
    }
    
}
-(void)setSexSelected:(sex)sex withSelectResult:(SexSelectedBlock)result
{
    if (sex==male)
    {
        //        self.maleBtn.selected = YES;
        //        self.femaleBtn.selected = NO;
        //        self.selecteSex = male;
        
        
        if ([[User LocalUser].sex isEqualToString:@"0"]) {
            self.maleBtn.selected = YES;
            self.femaleBtn.selected = NO;
            self.selecteSex = male;
            
        } else {
            self.maleBtn.selected = NO;
            self.femaleBtn.selected = YES;
            self.selecteSex = female;
        }
        
    }else
    {
        //        self.maleBtn.selected = NO;
        //        self.femaleBtn.selected = YES;
        //        self.selecteSex = female;
        
        
        if ([[User LocalUser].sex isEqualToString:@"0"]) {
            self.maleBtn.selected = YES;
            self.femaleBtn.selected = NO;
            self.selecteSex = male;
            
        } else {
            self.maleBtn.selected = NO;
            self.femaleBtn.selected = YES;
            self.selecteSex = female;
        }
    }
    
    
    
    self.result = result;
    
}
-(void)dealloc
{
    NSLog(@"%@销毁了",NSStringFromClass([self class]));
}
@end
