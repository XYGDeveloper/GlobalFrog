//
//  TopicDetailViewController.m
//  Qqw
//
//  Created by zagger on 16/9/2.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "TopicDetailViewController.h"

@implementation TopicDetailViewController

- (id)initWithTopicIdentifier:(NSString *)identifier {
    NSString *relativePath = [NSString stringWithFormat:@"/app-article/list?cate_id=%@",identifier];
    if (self = [super initWithURLString:H5URL(relativePath)]) {
        
    }
    return self;
}

@end
