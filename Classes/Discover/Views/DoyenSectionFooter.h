//
//  DoyenSectionFooter.h
//  Qqw
//
//  Created by zagger on 16/9/3.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  成为达人点击入口
 */
@interface DoyenSectionFooter : UICollectionReusableView

@property (nonatomic, copy) void(^clickBlock)(void);

+ (CGSize)footerSize;

@end
