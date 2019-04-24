//
//  DayenDetailViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2017/1/17.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "DayenDetailViewController.h"


@implementation DayenDetailViewController

- (id)initWithTopicIdentifier:(NSString *)uid position:(NSString *)postion{
    
    NSString *relativePath = [NSString stringWithFormat:@"/app-butler/detail?uid=%@&position=%@",uid,postion];
    if (self = [super initWithURLString:H5URL(relativePath)]) {
        NSLog(@"相对路径%@",H5URL(relativePath));
    }
    return self;
    
}

@end
