//
//  OrderDetailTrackCell.m
//  Qqw
//
//  Created by zagger on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderDetailTrackCell.h"
#import "OrderModel.h"

@interface OrderDetailTrackCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *trackLable;

@property (nonatomic, strong) UIImageView *rightArrowView;

@property (nonatomic, strong) UIView *topLineView;

@end

@implementation OrderDetailTrackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.topLineView];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.trackLable];
        [self.contentView addSubview:self.rightArrowView];
        
        [self configLayout];
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshWithTrack:(OrderTrack *)track {
    self.trackLable.text = track.content;
}


#pragma mark - Layout
- (void)configLayout {
    self.topLineView.hidden = YES;
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(12));
        make.centerY.equalTo(self);
    }];
    
    [self.trackLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(9);
        make.centerY.equalTo(self);
    }];
    
    [self.rightArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-9);
        make.centerY.equalTo(self);
    }];
}


#pragma mark - Properties
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orderDetail_track"]];
    }
    return _iconView;
}

- (UILabel *)trackLable {
    if (!_trackLable) {
        _trackLable = GeneralLabel(Font(14), TextColor1);
        _trackLable.numberOfLines = 2;
    }
    return _trackLable;
}

- (UIImageView *)rightArrowView {
    if (!_rightArrowView) {
        _rightArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Order_rightArrow"]];
    }
    return _rightArrowView;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = HexColor(0xe6e6e6);
    }
    return _topLineView;
}

@end
