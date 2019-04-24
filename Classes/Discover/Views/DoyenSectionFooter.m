//
//  DoyenSectionFooter.m
//  Qqw
//
//  Created by zagger on 16/9/3.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "DoyenSectionFooter.h"

@interface DoyenSectionFooter ()

@property (nonatomic, strong) UIButton *darenButton;

@end

@implementation DoyenSectionFooter

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.darenButton];
        
        [self.darenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.top.equalTo(@13);
            make.bottom.equalTo(@-13);
        }];
    }
    return self;
}

- (void)darenButtonClicked:(id)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

+ (CGSize)footerSize {
    CGFloat imageWidth = kScreenWidth - 20.0;
    CGFloat imageHeight = imageWidth * 140.0 / 355.0;
    
    return CGSizeMake(kScreenWidth, imageHeight + 26);
}


#pragma mark -
- (UIButton *)darenButton {
    if (!_darenButton) {
        _darenButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _darenButton.layer.cornerRadius = 5.0;
        _darenButton.layer.masksToBounds = YES;
        [_darenButton setBackgroundImage:[UIImage imageNamed:@"becom_daren.jpg"] forState:UIControlStateNormal];
        [_darenButton addTarget:self action:@selector(darenButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _darenButton;
}

@end
