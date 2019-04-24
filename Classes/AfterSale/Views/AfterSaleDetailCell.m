//
//  AfterSaleDetailCell.m
//  Qqw
//
//  Created by zagger on 16/9/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "AfterSaleDetailCell.h"

@interface AfterSaleDetailCell ()

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) UIImageView *tagImgView;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation AfterSaleDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self configLayout];
    }
    return self;
}

- (void)refreshWithModel:(AfterSaleDetailList *)model isTop:(BOOL)isTop {
    self.stateLabel.text = model.remark;
    self.timeLabel.text= [NSDate fullTimeStringWithInterval:model.dateline.doubleValue];
    
    self.topLineView.hidden = isTop;
    self.tagImgView.image = isTop ? [UIImage imageNamed:@"afterSale_detailListNewest"] : [UIImage imageNamed:@"afterSale_detailList"];
    self.stateLabel.textColor = isTop ? AppStyleColor : TextColor3;
    self.timeLabel.textColor = isTop ? AppStyleColor : TextColor3;
}

- (void)configLayout {
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.tagImgView];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@18);
        make.top.equalTo(@0);
        make.width.equalTo(@1);
    }];
    
    [self.tagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topLineView);
        make.top.equalTo(self.stateLabel.mas_centerY);
        make.top.equalTo(self.topLineView.mas_bottom);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLineView);
        make.top.equalTo(self.tagImgView.mas_bottom);
        make.width.equalTo(self.topLineView);
        make.bottom.equalTo(@1);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@45);
        make.right.equalTo(@-24);
        make.top.equalTo(@9);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@45);
        make.right.equalTo(@-24);
        make.bottom.equalTo(@-9);
    }];
}


#pragma mark - Properties
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = RGB(214, 215, 220);
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = RGB(214, 215, 220);
    }
    return _bottomLineView;
}

- (UIImageView *)tagImgView {
    if (!_tagImgView) {
        _tagImgView = [[UIImageView alloc] init];
    }
    return _tagImgView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = GeneralLabel(Font(12), AppStyleColor);
        _stateLabel.numberOfLines = 2;
    }
    return _stateLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = GeneralLabel(Font(11), AppStyleColor);
    }
    return _timeLabel;
}

@end
