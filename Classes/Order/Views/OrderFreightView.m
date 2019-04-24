//
//  OrderFreightView.m
//  Qqw
//
//  Created by zagger on 16/8/19.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderFreightView.h"
#import "OrderConfirmViewConfig.h"

@interface OrderFreightView ()

@property (nonatomic, strong) UILabel *fixLabel;

@property (nonatomic, strong) UILabel *freeTagLabel;//免邮标记
@property (nonatomic, strong) UIImageView *freeTagBgView;//免邮标记背景

@property (nonatomic, strong) UILabel *freightLabel;

@end

@implementation OrderFreightView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ORDER_CONFIRM_BACKGROUND_COLOR;
        
        [self addSubview:self.fixLabel];
        [self addSubview:self.freeTagBgView];
        [self addSubview:self.freeTagLabel];
        [self addSubview:self.freightLabel];
        
        [self configLayout];
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshWithFreight:(NSString *)freight showFreeTag:(BOOL)showFreeTag freeReason:(NSString *)freeReason {
    self.freightLabel.text = [Utils priceDisplayStringFromPrice:freight];
    
    //TODO:暂时不做
    showFreeTag = NO;
    
    if (showFreeTag) {
        self.freeTagBgView.hidden = NO;
        self.freeTagLabel.hidden = NO;
        self.freeTagLabel.text = freeReason;
    } else {
        self.freeTagBgView.hidden = YES;
        self.freeTagBgView.hidden = YES;
    }
}

#pragma mark - Layout
- (void)configLayout {
    [self.fixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(ORDER_CONFIRM_LEFT_MARGIN));
        make.centerY.equalTo(self);
    }];
    
    [self.freightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-1*ORDER_CONFIRM_RRIGHT_MARGIN));
        make.centerY.equalTo(self);
    }];
    
    [self.freeTagBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.freightLabel.mas_left).offset(-5);
        make.centerY.equalTo(self);
    }];
    
    [self.freeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.freeTagBgView);
        make.right.equalTo(self.freeTagBgView).offset(-5);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - Properties
- (UILabel *)fixLabel {
    if (!_fixLabel) {
        _fixLabel = [[UILabel alloc] init];
        _fixLabel.backgroundColor = [UIColor clearColor];
        _fixLabel.font = Font(13);
        _fixLabel.textColor = TextColor2;
        _fixLabel.text = @"配送";
    }
    
    return _fixLabel;
}

- (UILabel *)freeTagLabel {
    if (!_freeTagLabel) {
        _freeTagLabel = [[UILabel alloc] init];
        _freeTagLabel.backgroundColor = [UIColor clearColor];
        _freeTagLabel.font = Font(12);
        _freeTagLabel.textColor = AppStyleColor;
        _freeTagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _freeTagLabel;
}

- (UIImageView *)freeTagBgView {
    if (!_freeTagBgView) {
        _freeTagBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_freightBg"]];
    }
    return _freeTagBgView;
}

- (UILabel *)freightLabel {
    if (!_freightLabel) {
        _freightLabel = [[UILabel alloc] init];
        _freightLabel.backgroundColor = [UIColor clearColor];
        _freightLabel.font = Font(13);
        _freightLabel.textColor = TextColor2;
    }
    return _freightLabel;
}

@end
