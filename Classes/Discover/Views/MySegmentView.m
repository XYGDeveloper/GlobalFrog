//
//  MySegmentView.m
//  GoJobNow
//
//  Created by Sean on 15/11/12.
//  Copyright © 2015年 Sean. All rights reserved.
//

#import "MySegmentView.h"

@implementation MySegmentView

- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray*)array{
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        _scrollView.contentSize = CGSizeMake(80*array.count, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
     
        
        _contLablelist = [NSMutableArray array];
        
        float f = (self.width-50*array.count)/(array.count+1);
        
        _linView = [[UIView alloc]initWithFrame:CGRectMake(f, self.height-2, 50, 1.5)];
        _linView.backgroundColor = AppStyleColor;
        for (int i = 0 ; i<array.count; i++) {
            UIButton * but = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [but setTitle:array[i] forState:NO];
            but.titleLabel.font = [UIFont systemFontOfSize:15];
            but.frame = CGRectMake(f*(i+1)+50*i, 0, 50, self.height-1);
            but.tag = 10000+i;
            
            [but addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:but];
            if (i==0) {
                [but setTitleColor:AppStyleColor forState:NO];
                _selectBut = but;
            }else{
                [but setTitleColor:[UIColor darkGrayColor] forState:NO];
                
            }
        }
        [_scrollView addSubview:_linView];
        [self addSubview:_scrollView];
        
        UIView * l = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        l.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:l];
        
    }
    return self;
}


-(void)clickBut:(UIButton*)sender{
    if (_selectBut == sender) {
        
    }else{
        [_selectBut setTitleColor:[UIColor darkGrayColor] forState:NO];
        [sender setTitleColor:AppStyleColor forState:NO];
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:7 options:UIViewAnimationOptionLayoutSubviews animations:^{
            _linView.center = CGPointMake(sender.center.x, _linView.center.y);

        } completion:^(BOOL finished) {
            
        }];
        
        
        if (_delegate) {
            if ([self.delegate respondsToSelector:@selector(callBackSelectSegment:but:)]) {
                [self.delegate callBackSelectSegment:self but:sender];
            }
            if ([self.delegate respondsToSelector:@selector(callBackSelectSegmentWithtype:)]) {
                [self.delegate callBackSelectSegmentWithtype:(int)sender.tag-10000];
            }
        }
    }
    
    _selectBut = sender;
}

@end
