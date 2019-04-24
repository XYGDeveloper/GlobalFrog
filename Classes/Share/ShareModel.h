//
//  ShareModel.h
//  Qqw
//
//  Created by zagger on 16/8/26.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *img;
@property(nonatomic,strong) UIImage * scr_img;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, readonly) NSString *shareContent;

@end
