//
//  BaseCollectionViewCell.m
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@interface BaseCollectionViewCell ()

@property (nonatomic, strong) UIView *maskView;

@end

@implementation BaseCollectionViewCell

#ifdef __IPHONE_8_0
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    return layoutAttributes;
}
#endif

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.maskView.frame = self.contentView.bounds;
        [self.contentView addSubview:self.maskView];
    } else if (self.maskView.superview) {
        [self.maskView removeFromSuperview];
    }
}

+ (CGSize)cellItemSize {
    return CGSizeZero;
}


#pragma mark - Properties
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _maskView;
}

@end
