//
//  TopicListCell.h
//  Qqw
//
//  Created by zagger on 16/9/7.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopicItem;
@interface TopicListCell : UITableViewCell

- (void)refreshWithTopicItem:(TopicItem *)topicItem;

+ (CGFloat)heightForTopicItem:(TopicItem *)topicItem;

@end
