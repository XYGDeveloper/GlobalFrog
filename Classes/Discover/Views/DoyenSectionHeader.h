//
//  DoyenSectionHeader.h
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoyenSectionHeader : UICollectionReusableView

@property (nonatomic, copy) void(^actionBlock)(void);

- (void)refreshWithName:(NSString *)name;

@end
