//
//  QQWRefreshHeader.m
//  Qqw
//
//  Created by zagger on 16/8/22.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "QQWRefreshHeader.h"

@implementation QQWRefreshHeader

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {        
        self.stateLabel.hidden = YES;
        self.lastUpdatedTimeLabel.hidden = YES;
        
//        self.backgroundColor = DefaultBackgroundColor;
        
        NSMutableArray *refreshingImageArray = [[NSMutableArray alloc] initWithCapacity:21];
        for (int i = 1; i <= 21; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading-%d",i]];
            [refreshingImageArray safeAddObject:image];
        }
        
        
        [self setImages:refreshingImageArray duration:2.0 forState:MJRefreshStateRefreshing];
        [self setImages:refreshingImageArray duration:2.0 forState:MJRefreshStatePulling];
        [self setImages:refreshingImageArray duration:2.0 forState:MJRefreshStateIdle];
    }
    return self;
}



#pragma mark - 覆盖父类方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state{
    [super setImages:images duration:duration forState:state];
    
    self.mj_h = 54;
}

- (void)placeSubviews{
    [super placeSubviews];
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

@end

