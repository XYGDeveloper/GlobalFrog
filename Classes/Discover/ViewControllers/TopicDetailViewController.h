//
//  TopicDetailViewController.h
//  Qqw
//
//  Created by zagger on 16/9/2.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "WebViewController.h"

/**
 *  专题精选详情页，为一个专题下的文章列表
 */

@interface TopicDetailViewController : WebViewController

- (id)initWithTopicIdentifier:(NSString *)identifier;

@end
