//
//  CountEditView.m
//  Qqw
//
//  Created by zagger on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "CountEditView.h"

@interface CountEditView ()

@property (nonatomic, strong) UIButton *reduceButton;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIImageView *countBackgroundView;

@end

@implementation CountEditView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.count = 1;
        self.minCount = 1;
        self.maxCount = INT32_MAX;
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 2.0;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.reduceButton];
        [self addSubview:self.countBackgroundView];
        [self addSubview:self.countLabel];
        [self addSubview:self.addButton];
        
        [self configLayout];
        
        
        [self.reduceButton addTarget:self action:@selector(reducetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)configLayout {
    
    [self.reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(@0);
        make.width.equalTo(@41);
    }];
    
    [self.countBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(self.reduceButton.mas_right);
        make.right.equalTo(self.addButton.mas_left);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.countBackgroundView);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(@0);
        make.width.equalTo(@41);
    }];
}

#pragma mark - events
- (void)reducetButtonClicked:(id)sender {
    self.count = self.count - 1;
    self.addButton.enabled = self.count < self.maxCount;
    self.reduceButton.enabled = self.count > self.minCount;
    
    if (self.reduceButton) {
        self.reduceBlock();
    }
}

- (void)addButtonClicked:(id)sender {
    self.count = self.count + 1;
    self.addButton.enabled = self.count < self.maxCount;
    self.reduceButton.enabled = self.count > self.minCount;
    
    if (self.addBlock) {
        self.addBlock();
    }
}


#pragma mark - helper
- (UIButton *)operationButtonWithTitle:(NSString *)title
                       backgroundImage:(UIImage *)bgImage
                disableBackgroundImage:(UIImage *)disableBgImage {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [btn setBackgroundImage:disableBgImage forState:UIControlStateDisabled];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:11];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:HexColor(0x333333) forState:UIControlStateNormal];
    [btn setTitleColor:HexColor(0x999999) forState:UIControlStateDisabled];
    
    return btn;
}


#pragma mark - Properties
- (void)setCount:(NSInteger)count {
    if (count > self.maxCount || count < self.minCount) {
        return;
    }
    
    _count = count;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
    self.addButton.enabled = self.count < self.maxCount;
    self.reduceButton.enabled = self.count > self.minCount;
}

- (UIButton *)reduceButton {
    if (!_reduceButton) {
        _reduceButton = [self operationButtonWithTitle:@"-"
                                       backgroundImage:[UIImage imageNamed:@"cart_countLeft"]
                                disableBackgroundImage:[UIImage imageNamed:@""]];
    }
    
    return _reduceButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [self operationButtonWithTitle:@"+"
                                    backgroundImage:[UIImage imageNamed:@"cart_countRight"]
                             disableBackgroundImage:[UIImage imageNamed:@""]];
    }
    
    return _addButton;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = GeneralLabelA(Font(12), TextColor2, NSTextAlignmentCenter);
        _countLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return _countLabel;
}

- (UIImageView *)countBackgroundView {
    if (!_countBackgroundView) {
        _countBackgroundView = [[UIImageView alloc] init];
        _countBackgroundView.image = [UIImage imageNamed:@"cart_countMiddle"];
    }
    return _countBackgroundView;
}

@end
