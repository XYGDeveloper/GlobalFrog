//
//  LoadingView.m
//  Qqw
//
//  Created by zagger on 16/9/1.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()

@property (nonatomic, strong) UIImageView *gifView;

@end

@implementation LoadingView

+ (instancetype)generalLoadingView {
    LoadingView *view = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:21];
    for (int i = 1; i <= 21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading-%d",i]];
        [imageArray safeAddObject:image];
    }
    
    [view setAnimationDuration:1.5];
    [view setGifImages:imageArray];
    
    
    return view;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        
        self.gifView.frame = self.bounds;
        [self addSubview:self.gifView];
    }
    return self;
}

- (void)setGifImages:(NSArray<UIImage *> *)images {
    self.gifView.animationImages = images;
    [self.gifView startAnimating];
}

- (void)setAnimationDuration:(NSTimeInterval)duration {
    self.gifView.animationDuration = duration;
}



#pragma mark - Properties
- (UIImageView *)gifView {
    if (!_gifView) {
        _gifView = [[UIImageView alloc] init];
        _gifView.backgroundColor = [UIColor clearColor];
        _gifView.contentMode = UIViewContentModeScaleAspectFit;
        _gifView.clipsToBounds = YES;
    }
    return _gifView;
}

@end
