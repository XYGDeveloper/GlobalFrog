//
//  ViewExpand.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/15.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "ViewExpand.h"

@implementation UIView (Tags)

- (CGFloat)addTagLabels:(NSArray *)tags target:(id)target action:(SEL)action{
    UILabel *fixLabel = GeneralLabel(Font(13), TextColor1);
    fixLabel.text = @"热门搜索";
    [fixLabel sizeToFit];
    fixLabel.origin = CGPointMake(10, 12.0);
    [self addSubview:fixLabel];
    
    CGFloat mar = 10.f, x = mar, y = mar+30, w = 0, h = 0;
    @try {
        for (NSInteger i = 0; i < tags.count; i ++){
            UIButton *l = [UIButton buttonWithType:(UIButtonTypeSystem)];
            l.frame = CGRectMake(x, y, 0, 0);
            l.backgroundColor = [UIColor whiteColor];
            [l setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [l setTitle:tags[i] forState:NO];
            l.titleLabel.font = Font(13);
            l.layer.cornerRadius = 10;
            l.layer.masksToBounds = YES;
            l.layer.borderColor = TextColor2.CGColor;
            l.layer.borderWidth = 0.5;
            [l addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [l sizeToFit];
            
            [self addSubview:l];
            w = l.bounds.size.width + 10;
            h = l.bounds.size.height + 2;
            if ((x + w + mar) > self.bounds.size.width){
                x = mar;
                y += h + mar;
            }
            l.frame = CGRectMake(x, y, w, h);
            x += w + mar;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    return y + h + mar;
}

- (void)removeAllTagLabels{
    for (UIView *v in self.subviews){
//        if ([v isKindOfClass:[UIView class]]){
            [v removeFromSuperview];
//        }
    }
}


@end
