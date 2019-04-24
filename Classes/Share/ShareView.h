//
//  ShareView.h
//  Qqw
//
//  Created by zagger on 16/8/26.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareModel;
@interface ShareView : UIView

+ (void)showShareViewWithModel:(ShareModel *)model InViewController:(UIViewController *)parentVC;


@end



@interface ShareItemView : UIView

@property (nonatomic, copy) void(^shareBlock)(NSString *platform);

- (id)initWithIcon:(UIImage *)iconImage name:(NSString *)name platform:(NSString *)platform;

@end
