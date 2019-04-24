//
//  CountEditView.h
//  Qqw
//
//  Created by zagger on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountEditView : UIView

@property (nonatomic, assign) NSInteger count;//当前编辑的数量

@property (nonatomic, assign) NSInteger maxCount;//最大数量，默认为无穷大

@property (nonatomic, assign) NSInteger minCount;//最小数量，默认为1

@property (nonatomic, copy) void(^reduceBlock)(void);

@property (nonatomic, copy) void(^addBlock)(void);


@end
