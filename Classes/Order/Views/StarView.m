//
//  StarView.m
//  Qqw
//
//  Created by zagger on 16/8/29.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "StarView.h"

#define MAX_STAR_COUNT 5

@interface StarView ()

@property (nonatomic, strong) NSMutableArray *starButtonArray;

@end

@implementation StarView

+ (instancetype)generalStarView {
    return [[StarView alloc] initWithFrame:CGRectMake(0, 0, 90.0, 18.0)];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.starButtonArray = [[NSMutableArray alloc] initWithCapacity:5];
        
        CGFloat buttonWidth = 18.0;
        for (int i = 0; i < MAX_STAR_COUNT; i ++) {
            UIButton *starButton = [self starButton];
            starButton.frame = CGRectMake(i * buttonWidth, 0.5*(self.height - buttonWidth), buttonWidth, buttonWidth);
            
            [self addSubview:starButton];
            [self.starButtonArray safeAddObject:starButton];
        }
    }
    
    return self;
}



#pragma mark - Events
- (void)starButtonClicked:(UIButton *)sender {
    NSInteger index = [self.starButtonArray indexOfObject:sender];
    self.star = index + 1;
    
    if (self.starDidChangeBlock) {
        self.starDidChangeBlock(self.star);
    }
}

- (void)setStar:(NSInteger)star {
    if (star < 0 || star > MAX_STAR_COUNT) {
        _star = 0;
    }
    
    if (_star != star) {
        _star = star;
        for (int i = 0; i < self.starButtonArray.count; i++) {
            UIButton *starButton = [self.starButtonArray safeObjectAtIndex:i];
            starButton.selected = i < star;
        }
    }
}

#pragma mark - Helper
- (UIButton *)starButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:@"orderCmt_star_normal"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"orderCmt_star_selected"] forState:UIControlStateSelected];
    
    [btn addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

@end
