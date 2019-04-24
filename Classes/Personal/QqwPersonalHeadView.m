//
//  QqwPersonalHeadView.m
//  Qqw
//
//  Created by 全球蛙 on 16/7/15.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "QqwPersonalHeadView.h"
@interface QqwPersonalHeadView ()


@end

@implementation QqwPersonalHeadView

-(instancetype)init{
    if(self=[super init]){
        [self loadview];
        self.backgroundColor =[UIColor colorWithRed:0.169 green:0.600 blue:0.141 alpha:1.000];
    }
    return self;
}

-(UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc]init];
        _bgImg.image = [UIImage imageNamed:@"HEAD_BG"];
        _bgImg.userInteractionEnabled = YES;
        _bgImg.contentMode = UIViewContentModeScaleAspectFill;
        _bgImg.clipsToBounds = YES;
     
    }
    return _bgImg;
}

-(UIImageView *)headImage{
    if (!_headImage) {
         _headImage = [UIImageView new];
        _headImage.contentMode = UIViewContentModeScaleToFill;
        _headImage.userInteractionEnabled = YES;
        [_headImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTouchAction)]];
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 30.0f;
        _headImage.contentMode = UIViewContentModeScaleAspectFill;
        _headImage.clipsToBounds = YES;
    }
    return _headImage;
}

-(UILabel *)accountLabel{
    if (!_accountLabel) {
        _accountLabel = [UILabel new];
        _accountLabel.textColor = [UIColor whiteColor];
        _accountLabel.textAlignment = NSTextAlignmentCenter;
        _accountLabel.userInteractionEnabled = YES;
        [_accountLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTouchAction)]];
        [_accountLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LabelTouchAction)]];
        _accountLabel.font = [UIFont systemFontOfSize:16];
        _accountLabel.userInteractionEnabled = YES;
    }
    return _accountLabel;
}

-(UILabel *)LevelLabel{
    if (!_LevelLabel) {
        _LevelLabel = [UILabel new];
        _LevelLabel.textColor = [UIColor whiteColor];
        _LevelLabel.textAlignment = NSTextAlignmentCenter;
        _LevelLabel.userInteractionEnabled = YES;
//        _LevelLabel.text = @"text";
        _LevelLabel.font = [UIFont systemFontOfSize:14.0f];
        _LevelLabel.font = [UIFont systemFontOfSize:16];
        _LevelLabel.userInteractionEnabled = YES;

    }
    return _LevelLabel;
}

-(UIButton *)attentionButton{
    if (!_attentionButton) {
        _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionButton setTitle:@"收藏" forState:UIControlStateNormal];
        _attentionButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _attentionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_attentionButton setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [_attentionButton addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _attentionButton;
}

-(UIButton *)collectionButton{
    if (!_collectionButton) {
        _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionButton setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [_collectionButton setTitle:@"关注" forState:UIControlStateNormal];
        _collectionButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _collectionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_collectionButton addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionButton;
}

-(UIButton *)InfoButton{
    if (!_InfoButton) {
        _InfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_InfoButton setBackgroundImage:[UIImage imageNamed:@"person_scanInfo"] forState:UIControlStateNormal];
//        _InfoButton.imageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
//        _InfoButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        [_InfoButton addTarget:self action:@selector(scanInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _InfoButton;
}

-(UIButton *)noticeInfo{
    if (!_noticeInfo) {
        _noticeInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        _noticeInfo.layer.cornerRadius = 5;
    }
    return _noticeInfo;
}
-(void)loadview{
    [self addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_equalTo(0);
    }];
    
    [self addSubview:self.headImage];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.with.height.mas_equalTo(60);
        make.centerX.mas_equalTo(self.centerX);
        make.top.mas_equalTo(50);
    }];
    
    [self addSubview:self.accountLabel];
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImage.mas_bottom).mas_equalTo(5);
        make.centerX.mas_equalTo(self.centerX);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(150);
        
    }];
    
    [self addSubview:self.LevelLabel];
    [self.LevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountLabel.mas_bottom).mas_equalTo(2);
        make.centerX.mas_equalTo(self.centerX);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(150);
    }];
    
    [self addSubview:self.attentionButton];
    [self.attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(kScreenWidth/2-0.5);
    }];
    
    [self addSubview:self.collectionButton];
    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.left.mas_equalTo(self.attentionButton.mas_right).mas_equalTo(1);
        make.width.mas_equalTo(kScreenWidth/2-0.5);
    }];
    
    UIView * linview = [UIView new];
    linview.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self addSubview:linview];
    [linview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.attentionButton.mas_right);
        make.right.equalTo(self.collectionButton.mas_left);
        make.height.equalTo(self.attentionButton.mas_height);
        make.bottom.mas_equalTo(0);
    }];
    
    [self addSubview:self.InfoButton];
    [self.InfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(28);
        make.right.mas_equalTo(self.mas_right).offset(-13);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.noticeInfo];
    [self.noticeInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.InfoButton.mas_right).mas_equalTo(-5);
        make.top.mas_equalTo(self.InfoButton.mas_top).mas_equalTo(-5);
        make.width.height.mas_equalTo(10);
        
    }];
}


- (void)attentionAction:(UIButton *)btn{
    if (self.attention) {
        self.attention();
    }
}

- (void)collectionAction:(UIButton *)btn{
    if (self.collection) {
        self.collection();
    }
}

- (void)scanInfoAction:(UIButton *)button{
    if (self.info) {
        self.info();
    }
}



- (void)LabelTouchAction{
    if (self.labelTouch) {
        self.labelTouch();
    }
}

-(void)headTouchAction{
    if (self.touchAction) {
        self.touchAction();
    }
}

-(void)setHeadImage:(NSString *)url withLeve:(NSString *)leve withAccountName:(NSString *)accountName{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"HEADER"]];
    self.LevelLabel.text = leve;
    self.accountLabel.text = accountName;
}

@end
