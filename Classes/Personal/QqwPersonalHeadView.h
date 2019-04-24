//
//  QqwPersonalHeadView.h
//  Qqw
//
//  Created by 全球蛙 on 16/7/15.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TouchHeadImageBlcok)();
typedef void(^TouchHeadLabelBlcok)();
typedef void(^attentionBlock)();
typedef void(^collectionBlock)();
typedef void(^scanInfo)();
@interface QqwPersonalHeadView : UIView
@property (nonatomic,copy)TouchHeadImageBlcok touchAction;
@property (nonatomic,copy)TouchHeadLabelBlcok labelTouch;
//关注和收藏
@property (nonatomic,copy)attentionBlock attention;
@property (nonatomic,copy)collectionBlock collection;
@property (nonatomic,copy)scanInfo info;
@property (nonatomic,strong)UIImageView *bgImg;
@property (nonatomic,strong)UIImageView* levelImage;
@property (nonatomic,strong)UILabel* accountLabel;
@property (nonatomic,strong)UIImageView* headImage;
@property (nonatomic,strong)UILabel *LevelLabel;
//关注和收藏
@property (nonatomic,strong)UIButton *attentionButton;
@property (nonatomic,strong)UIButton *collectionButton;
//消息中心
@property (nonatomic,strong)UIButton *InfoButton;
@property (nonatomic,strong)UIButton *noticeInfo;

-(void)setHeadImage:(NSString*)url withLeve:(NSString*)leve withAccountName:(NSString*)accountName;

@end
