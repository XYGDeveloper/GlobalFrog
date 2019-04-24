//
//  DefaultTableViewCell.m
//  Qqw
//
//  Created by XYG on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "DefaultTableViewCell.h"
#import "AddressModel.h"
@implementation DefaultTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.nikeName = [[UILabel alloc]init];
        [self.contentView addSubview:_nikeName];
        self.nikeName.font = [UIFont systemFontOfSize:14.0f];
        self.nikeName.textColor = [UIColor colorWithWhite:0.535 alpha:1.000];
        self.telephone = [[UILabel alloc]init];
        [self.contentView addSubview:_telephone];
        self.telephone.textColor = [UIColor colorWithWhite:0.597 alpha:1.000];
        self.telephone.font = [UIFont systemFontOfSize:12.0f];

        self.telephone.textAlignment = NSTextAlignmentRight;
        self.address = [[UILabel alloc]init];
        [self.contentView addSubview:_address];
        self.address.textColor = [UIColor colorWithWhite:0.554 alpha:1.000];
        self.address.font = [UIFont systemFontOfSize:13.0f];
        
        self.faultAddress = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_faultAddress];
        [self.faultAddress addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //为了解决按钮不流畅，在上面覆盖一层透明的按钮层按钮
        self.defaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_defaButton];
        self.defaButton.backgroundColor = [UIColor clearColor];
        [self.defaButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
     
        self.label = [[UILabel alloc]init];
        [self.contentView addSubview:_label];
        self.label.font = [UIFont systemFontOfSize:13.0f];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.textColor = [UIColor colorWithRed:0.000 green:0.536 blue:0.001 alpha:1.000];
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_editButton];
        [self.editButton setBackgroundImage:[UIImage imageNamed:@"center"] forState:UIControlStateNormal];
        
         [self.editButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editAddress)]];
        //上面覆盖一个透明的按钮，为了解决按钮不流畅的问题
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_btn];
       // self.btn.backgroundColor = [UIColor redColor];
        self.btn.backgroundColor = [UIColor clearColor];
        [self.btn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editAddress)]];
        
        UIView * linView = [[UIView alloc]init];
        linView.backgroundColor = [UIColor rgb:@"f4f4f4"];
        [self addSubview:linView];
        
        [linView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.textLabel.textColor =HexColorA(0x323232,0.8);
    self.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
    
    
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
        make.top.mas_equalTo(_address.mas_bottom).mas_equalTo(12);
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(14);
    
    }];
   
  
    [self.defaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_address.mas_bottom).mas_equalTo(-30);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(70);
        
    }];
    
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_address.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(_faultAddress.mas_right).mas_equalTo(3);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
        
    }];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_address.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(-5);
        make.width.height.mas_equalTo(16);
        make.height.mas_equalTo(16);
        
    }];
    
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_address.mas_bottom).mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(0);
        make.width.height.mas_equalTo(100);
        make.height.mas_equalTo(36);
        
    }];
    

}


- (void)editAddress
{

    if (self.editBlock) {
        self.editBlock();
    }
    
}


-(void)btnAction:(UIButton*)btn
{
    
    if (self.btnAction) {
        self.btnAction(self.model);
    }
    
}


- (void)setModel:(AddressModel *)model{
    _model = model;
    if (model.is_default ==YES) {
        NSLog(@"---------%d",model.is_default);
        [self.faultAddress setBackgroundImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateNormal];
        self.label.text = @"默认地址";
    }else{
        [self.faultAddress setBackgroundImage:[UIImage imageNamed:@"sel_1"] forState:UIControlStateNormal];
        self.label.text = @"设为默认";
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
