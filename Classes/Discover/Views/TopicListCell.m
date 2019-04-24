//
//  TopicListCell.m
//  Qqw
//
//  Created by zagger on 16/9/7.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "TopicListCell.h"
#import "TopicItem.h"

@interface TopicListCell ()

@property (nonatomic, strong) UIImageView *topicImgView;

@property (nonatomic, strong) UILabel *topicNameLabel;

@property (nonatomic, strong) UILabel *topicIntroLabel;

@property (nonatomic, strong) UILabel *topicArticleCountLabel;

@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UIView *logoImgBgView;

@property (nonatomic, strong) UIView *dividerLineView1;
@property (nonatomic, strong) UIView *dividerLineView2;

@property (nonatomic,strong) UILabel *label;

@property (nonatomic, strong) UIView *maskView;


@end

@implementation TopicListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configLayout];
    }
    
    return self;
}

- (void)refreshWithTopicItem:(TopicItem *)topicItem {
    [self.topicImgView sd_setImageWithURL:[NSURL URLWithString:topicItem.images] placeholderImage:[UIHelper smallPlaceholder]];
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:topicItem.logo] placeholderImage:[UIHelper smallPlaceholder]];
    
    self.topicNameLabel.text = topicItem.name;
    self.topicIntroLabel.text = topicItem.slogan;
    
    self.topicArticleCountLabel.text = [NSString stringWithFormat:@"%@篇文章", topicItem.article_num];
}

+ (CGFloat)heightForTopicItem:(TopicItem *)topicItem {
    return 200.0 * kScreenWidth / 375.0;
}

#pragma mark - Layout
- (void)configLayout {
    [self.contentView addSubview:self.topicImgView];
    [self.contentView addSubview:self.maskView];
    [self.contentView addSubview:self.logoImgBgView];
    [self.contentView addSubview:self.logoImgView];
    [self.contentView addSubview:self.topicIntroLabel];
    [self.contentView addSubview:self.dividerLineView1];
    [self.contentView addSubview:self.topicNameLabel];
    [self.contentView addSubview:self.dividerLineView2];
    [self.contentView addSubview:self.topicArticleCountLabel];
    
    CGFloat hMargin = 32.0;
    
    [self.topicImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.logoImgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20.0);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@44.0);
        make.height.equalTo(@44.0);
    }];
    
    [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.logoImgBgView);
        make.width.equalTo(@40.0);
        make.height.equalTo(@40.0);
    }];
    
    [self.topicIntroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImgBgView.mas_bottom).offset(12);
        make.left.equalTo(@(hMargin));
        make.right.equalTo(@(-1*hMargin));
    }];
    
    [self.dividerLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.right.equalTo(@(-1*hMargin));
        make.height.equalTo(@(1.0));
        make.top.equalTo(self.topicIntroLabel.mas_bottom).offset(7.0);
    }];
    
    [self.topicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.right.equalTo(@(-1*hMargin));
        make.height.equalTo(@(45.0));
        make.top.equalTo(self.dividerLineView1.mas_bottom);
    }];
    
    [self.dividerLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.right.equalTo(@(-1*hMargin));
        make.height.equalTo(@(1.0));
        make.top.equalTo(self.topicNameLabel.mas_bottom);
    }];
    
    [self.topicArticleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.right.equalTo(@(-1*hMargin));
        make.top.equalTo(self.dividerLineView2.mas_bottom).offset(12);
    }];
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

- (UILabel *)topicNameLabel {
    if (!_topicNameLabel) {
        _topicNameLabel = GeneralLabelA(Font(24), [UIColor whiteColor], NSTextAlignmentCenter);
    }
    return _topicNameLabel;
}

- (UILabel *)topicIntroLabel {
    if (!_topicIntroLabel) {
        _topicIntroLabel = GeneralLabelA(Font(13), [UIColor whiteColor], NSTextAlignmentCenter);
    }
    return _topicIntroLabel;
}

- (UILabel *)topicArticleCountLabel {
    if (!_topicArticleCountLabel) {
        _topicArticleCountLabel = GeneralLabelA(Font(13), [UIColor whiteColor], NSTextAlignmentCenter);
    }
    return _topicArticleCountLabel;
}

- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] init];
        _logoImgView.clipsToBounds = YES;
        _logoImgView.contentMode = UIViewContentModeScaleAspectFill;
        
        _logoImgView.layer.cornerRadius = 20;
        _logoImgView.layer.masksToBounds = YES;
    }
    return _logoImgView;
}

- (UIView *)logoImgBgView {
    if (!_logoImgBgView) {
        _logoImgBgView = [[UIView alloc] init];
        _logoImgBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        
        _logoImgBgView.layer.cornerRadius = 22;
        _logoImgBgView.layer.masksToBounds = YES;
    }
    return _logoImgBgView;
}

- (UIView *)dividerLineView1 {
    if (!_dividerLineView1) {
        _dividerLineView1 =  [[UIView alloc] init];
        _dividerLineView1.backgroundColor = [UIColor whiteColor];
    }
    return _dividerLineView1;
}

- (UIView *)dividerLineView2 {
    if (!_dividerLineView2) {
        _dividerLineView2 = [[UIView alloc] init];
        _dividerLineView2.backgroundColor = [UIColor whiteColor];
    }
    return _dividerLineView2;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _maskView;
}


@end
