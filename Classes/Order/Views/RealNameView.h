//
//  RealNameView.h
//  Qqw
//
//  Created by 全球蛙 on 2017/1/6.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RealListModel;

@interface RealNameView : UIView

@property (nonatomic, strong)UILabel *realNameAuthoLabel;

@property (nonatomic, strong) UIButton *defaultTagView;

@property (nonatomic, strong)UILabel *isDefaultLabel;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *rightArrowView;

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, copy) void(^selectRealNameAuthoBlock)(void);

- (void)refreshWithRealNameAuthoTips:(RealListModel *)model;

@end
