//
//  MySegmentView.h
//  GoJobNow
//
//  Created by Sean on 15/11/12.
//  Copyright © 2015年 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MySegmentViewDelegate;

@interface MySegmentView : UIView{
    NSMutableArray * _contLablelist;
}
@property(nonatomic,assign) id<MySegmentViewDelegate> delegate;

@property(nonatomic,strong,readonly) UIScrollView * scrollView;

@property(nonatomic,strong,readonly) UIView * linView;

@property(nonatomic,strong,readonly) UIButton * selectBut;

- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray*)array;


@end

@protocol MySegmentViewDelegate <NSObject>

@optional
-(void)callBackSelectSegment:(MySegmentView*)segment but:(UIButton*)sender;

-(void)callBackSelectSegmentWithtype:(int)tag;

@end
