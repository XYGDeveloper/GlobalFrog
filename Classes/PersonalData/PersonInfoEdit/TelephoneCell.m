//
//  TelephoneCell.m
//  Qqw
//
//  Created by XYG on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "TelephoneCell.h"

@implementation TelephoneCell


-(UILabel *)titleLab
{
    if (!_titleLab) {
        
        _titleLab = [[UILabel alloc] init];
        
        _titleLab.textAlignment = NSTextAlignmentLeft;
        
        _titleLab.textColor = [UIColor blackColor];
        
        _titleLab.font = [UIFont systemFontOfSize:15.0f];
        
        [self.contentView addSubview:_titleLab];
        
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(20.0f);
            make.width.mas_equalTo(80.0f);
            make.height.mas_equalTo(self.mas_height);
        }];
    }
    
    return _titleLab;
}

-(UILabel *)contentLab
{
    if (!_contentLab) {
        
        _contentLab = [[UILabel alloc] init];
        
        _contentLab.textAlignment = NSTextAlignmentLeft;
        
        _contentLab.textColor = HexColorA(0x323232,0.8);
        
        _contentLab.font = [UIFont systemFontOfSize:15.0f];
        
        [self.contentView addSubview:_contentLab];
        
        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.titleLab.mas_right);
            make.width.mas_equalTo(self.mas_width).offset(-100);
            make.height.mas_equalTo(self.mas_height);
            
        }];
    }
    return _contentLab;
}

-(void)setTitle:(NSString *)title withContent:(NSString *)content
{
    self.titleLab.text = title;
    self.contentLab.text = content;
    
}
-(void)dealloc
{
    NSLog(@"%@销毁了",NSStringFromClass([self class]));
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
