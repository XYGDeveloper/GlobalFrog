//
//  DoyenArticleListViewController.m
//  Qqw
//
//  Created by zagger on 16/9/2.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "DoyenArticleListViewController.h"

@implementation DoyenArticleListViewController


- (id)initWithTopicIdentifier:(NSString *)identifier  {
    NSString *relativePath = [NSString stringWithFormat:@"/app-doyen/detail?doyen_id=%@",identifier];
    if (self = [super initWithURLString:H5URL(relativePath)]) {
        
    }
    return self;
}

@end
