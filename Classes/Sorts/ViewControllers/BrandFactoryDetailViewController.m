//
//  BrandFactoryDetailViewController.m
//  Qqw
//
//  Created by zagger on 16/9/9.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BrandFactoryDetailViewController.h"

@implementation BrandFactoryDetailViewController

- (id)initWithBrandFactoryIdentifier:(NSString *)brandFactoryId {
    NSString *relativePath = [NSString stringWithFormat:@"/app-goods/brand?brand_id=%@",brandFactoryId];
    NSString *urlString = H5URL(relativePath);
    if (self = [super initWithURLString:urlString]) {
        self.useHtmlTitle = YES;
    }
    return self;
}

@end
