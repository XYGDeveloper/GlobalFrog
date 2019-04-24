//
//  DoyenListCell.m
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "DoyenListCell.h"
#import "DoyenListItem.h"
@interface DoyenListCell ()

@property (nonatomic, strong) UIImageView *topicImgView;
@property (nonatomic, strong) UILabel *topicNameLabel;

@property (nonatomic, strong) UILabel *topicIntroLabel;

@property (nonatomic, strong) UILabel *topicArticleCountLabel;

@property (nonatomic, strong) UIImageView *userImgView;
@property (nonatomic, strong) UIView *userImgBgView;

@property (nonatomic, strong) UIImageView *jianbianBg;

@property (nonatomic, strong) UILabel *usernameLabel;



@end

@implementation DoyenListCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = HexColor(0xfbfbfb);
        
        self.contentView.layer.cornerRadius = 5.0;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderColor = HexColor(0xcccccc).CGColor;
        self.contentView.layer.borderWidth = 0.5;
        
        [self.contentView addSubview:self.topicImgView];
       
        [self.contentView addSubview:self.userImgBgView];
        [self.contentView addSubview:self.jianbianBg];
        [self.contentView addSubview:self.userImgView];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.topicNameLabel];
        [self.contentView addSubview:self.topicIntroLabel];
        [self.contentView addSubview:self.topicArticleCountLabel];
        [self.contentView addSubview:self.attentionButton];
        [self.attentionButton addTarget:self action:@selector(toAttention:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.attentionState];
        [self.contentView addSubview:self.attentionCount];
     
        [self.attentionButton setBackgroundImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateSelected];
        [self.attentionButton setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
        
        self.attentionButton.selected = !self.attentionButton.selected;
        self.attentionState.selected = !self.attentionState.selected;
        if (self.attentionButton.selected == YES) {
            [self.attentionButton setBackgroundImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateSelected];
             [self.attentionState setBackgroundImage:[UIImage imageNamed:@"Dayen_attention_selected"] forState:UIControlStateSelected];
        }else
        {
            
            [self.attentionButton setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
             [self.attentionState setBackgroundImage:[UIImage imageNamed:@"Dayen_attention_normal"] forState:UIControlStateNormal];
            
        }
        
        
        
        [self configLayout];
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshWithListItem:(DoyenItem *)dayenItem {
    [self.topicImgView sd_setImageWithURL:[NSURL URLWithString:dayenItem.show_picture] placeholderImage:[UIHelper smallPlaceholder]];
    [self.userImgView sd_setImageWithURL:[NSURL URLWithString:dayenItem.face] placeholderImage:[UIHelper smallPlaceholder]];
    
    self.attentionState.selected = !self.attentionState.selected;
    if (self.attentionState.selected == YES) {
        [self.attentionState setBackgroundImage:[UIImage imageNamed:@"Dayen_attention_selected"] forState:UIControlStateSelected];
    }else{
        [self.attentionState setBackgroundImage:[UIImage imageNamed:@"Dayen_attention_normal"] forState:UIControlStateNormal];
    }
    if ([dayenItem.isFollow isEqualToString:@"1"]) {

        self.attentionButton.selected = YES;
        self.attentionState.selected = YES;
        
       
    }else{
      
        self.attentionButton.selected = NO;
        self.attentionState.selected = NO;

    }
    
    self.attentionCount.text = [NSString stringWithFormat:@"%@人关注", dayenItem.follows];
    self.usernameLabel.text = dayenItem.nickname;
    self.topicNameLabel.text = dayenItem.name;
    self.topicIntroLabel.text = dayenItem.slogan;
    self.topicArticleCountLabel.text = dayenItem.msg;//[NSString stringWithFormat:@"%@篇文章", dayenItem.article_num];
    
    self.item = dayenItem;
}


#pragma mark - Layout
- (void)configLayout {
    
    [self.topicImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@([[self class] imageHeight]));
    }];
    [self.jianbianBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.attentionState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    [self.attentionCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.left.mas_equalTo(self.attentionState.mas_right).mas_equalTo(2);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    
    [self.userImgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.topicImgView.mas_bottom);
        make.width.height.equalTo(@60);
    }];
    
    [self.userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.userImgBgView);
        make.width.height.equalTo(@50);
    }];
    
    CGFloat hMargin = 5.0;
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.right.equalTo(@(-1*hMargin));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.userImgView.mas_bottom).offset(5);
    }];
    
    [self.topicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.right.equalTo(@(-1*hMargin));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(5);
    }];
    
    [self.topicIntroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.right.equalTo(@(-1*hMargin));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.topicNameLabel.mas_bottom).offset(6);
    }];
    
    [self.topicArticleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.right.equalTo(@(-1*hMargin));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.topicIntroLabel.mas_bottom).offset(5);
    }];
    
    [self.attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.topicArticleCountLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    
}


#pragma mark - size
+ (CGFloat)imageHeight {
    CGFloat hMargin = 10.0;
    CGFloat hPadding = 10.0;
    CGFloat imageWidth = (kScreenWidth - 2*hMargin - hPadding) / 2.0;
    
    return imageWidth * 0.75;
}

+ (CGSize)cellItemSize {
    CGFloat hMargin = 10.0;
    CGFloat hPadding = 10.0;
    CGFloat itemWidth = (kScreenWidth - 2*hMargin - hPadding) / 2.0;
    CGFloat itemHeight = [self imageHeight] + 160.0;
    
    return CGSizeMake(itemWidth, itemHeight);
}


#pragma mark - Properties
- (UIImageView *)topicImgView {
    if (!_topicImgView) {
        _topicImgView = [[UIImageView alloc] init];
        _topicImgView.clipsToBounds = YES;
        _topicImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _topicImgView;
}

- (UIImageView *)jianbianBg {
    if (!_jianbianBg) {
        
        _jianbianBg = [[UIImageView alloc] init];
        _jianbianBg.image = [UIImage imageNamed:@"jianbian"];
        _jianbianBg.clipsToBounds = YES;
        _jianbianBg.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _jianbianBg;
}


- (UILabel *)topicNameLabel {
    if (!_topicNameLabel) {
        _topicNameLabel = GeneralLabelA(Font(16), TextColor1, NSTextAlignmentCenter);
    }
    return _topicNameLabel;
}

- (UILabel *)topicIntroLabel {
    if (!_topicIntroLabel) {
        _topicIntroLabel = GeneralLabelA(Font(12), TextColor2, NSTextAlignmentCenter);
    }
    return _topicIntroLabel;
}

- (UILabel *)topicArticleCountLabel {
    if (!_topicArticleCountLabel) {
        _topicArticleCountLabel = GeneralLabelA(Font(12), TextColor2, NSTextAlignmentCenter);
    }
    return _topicArticleCountLabel;
}

- (UIImageView *)userImgView {
    if (!_userImgView) {
        _userImgView = [[UIImageView alloc] init];
        _userImgView.clipsToBounds = YES;
        _userImgView.contentMode = UIViewContentModeScaleAspectFill;
        
        _userImgView.layer.cornerRadius = 25.0;
        _userImgView.layer.masksToBounds = YES;
    }
    return _userImgView;
}

- (UIView *)userImgBgView {
    if (!_userImgBgView) {
        _userImgBgView = [[UIView alloc] init];
        _userImgBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        
        _userImgBgView.layer.cornerRadius = 30.0;
        _userImgBgView.layer.masksToBounds = YES;
    }
    return _userImgBgView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = GeneralLabelA(Font(14), TextColor1, NSTextAlignmentCenter);
    }
    return _usernameLabel;
}

- (UIButton *)attentionButton
{

    if (!_attentionButton) {
        _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _attentionButton;
}

//关注状态
- (UIButton *)attentionState
{

    if (!_attentionState) {
        _attentionState = [UIButton buttonWithType:UIButtonTypeCustom];

    }
    return _attentionState;
}

- (UILabel *)attentionCount {
    if (!_attentionCount) {
        _attentionCount = GeneralLabelA(Font(14), [UIColor whiteColor], NSTextAlignmentLeft);
    }
    return _attentionCount;
}

//去关注
- (void)toAttention:(UIButton *)attention{
    
    if (self.attention) {
        self.attention(self.item);
    }

}



@end
