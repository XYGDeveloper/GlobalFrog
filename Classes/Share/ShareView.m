//
//  ShareView.m
//  Qqw
//
//  Created by zagger on 16/8/26.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//
#import "ShareView.h"
#import "ShareModel.h"
#import "RootManager.h"
#import <UMSocial.h>
#import "ShareApi.h"
#import "WXApi.h"
#import "Utils.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "BaseApi.h"
#import "UMSocialDataService.h"

@interface ShareView ()<UMSocialUIDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *dividerLineView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) ShareModel *model;

@property (nonatomic, weak) UIViewController *parentVC;

@end

@implementation ShareView

+ (void)showShareViewWithModel:(ShareModel *)model InViewController:(UIViewController *)parentVC {
    ShareView *view = [[ShareView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    view.model = model;
    view.parentVC = parentVC;
    [view show];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        
        [self.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.closeButton];
        [self.contentView addSubview:self.dividerLineView];
        
        [self configLayout];
        [self configContentView];
    }
    return self;
}

- (void)configLayout {
    self.contentView.frame = CGRectMake(0, self.height - 184.0, self.width, 184.0);
    self.dividerLineView.frame = CGRectMake(0, self.contentView.height - 44.0, self.contentView.width, 0.5);
    self.closeButton.frame = CGRectMake(0, self.contentView.height - 44.0, self.contentView.width, 44.0);
}

- (void)configContentView {
    ShareItemView *wxTimeline = [[ShareItemView alloc] initWithIcon:[UIImage imageNamed:@"share_wechatTimeline"] name:@"朋友圈" platform:UMShareToWechatTimeline];
    ShareItemView *wxSession = [[ShareItemView alloc] initWithIcon:[UIImage imageNamed:@"share_wechatSessoin"] name:@"微信好友" platform:UMShareToWechatSession];
    ShareItemView *sina = [[ShareItemView alloc] initWithIcon:[UIImage imageNamed:@"share_sina"] name:@"新浪微博" platform:UMShareToSina];
    ShareItemView *qq = [[ShareItemView alloc] initWithIcon:[UIImage imageNamed:@"share_qq"] name:@"QQ好友" platform:UMShareToQQ];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:4];
    if ([WXApi isWXAppInstalled]) {
        [array safeAddObject:wxTimeline];
        [array safeAddObject:wxSession];
    }
    
    [array safeAddObject:sina];
    if ([TencentOAuth iphoneQQInstalled]) {
        [array safeAddObject:qq];
    }
    
    CGFloat itemWidth = 55.0;
    CGFloat itemHeight = 70;
    CGFloat padding = (self.width - itemWidth*4.0) / 5.0;
    for (ShareItemView *itemView in array) {
        
        __weak typeof(self) wself = self;
        
        itemView.shareBlock = ^(NSString *platform) {
            __strong typeof(wself) sself = wself;
     
            [sself shareWithPlatform:platform];
            
        };
        
        itemView.size = CGSizeMake(itemWidth, itemHeight);
        itemView.top = 0.5*(140.0 - itemHeight);
        
        NSInteger index = [array indexOfObject:itemView];
        itemView.left = padding + index*(itemWidth + padding);
        [self.contentView addSubview:itemView];
        
    }
}

#pragma mark - Events
- (void)closeButtonClicked:(id)sender {
    [self dismiss];
}

- (void)shareWithPlatform:(NSString *)platform{
    if (!platform) {
        return;
    }

    NSString *endString = self.model.url;
    
    if (platform == UMShareToQQ) {
        UMSocialUrlResource *urlsource = nil;
        if (self.model.scr_img) {
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
           
        }else{
            [UMSocialData defaultData].extConfig.title = self.model.title;
            [UMSocialData defaultData].extConfig.qqData.url = endString;
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
            urlsource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.model.img];
        }
      
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ]
                                                            content:self.model.shareContent
                                                              image:self.model.scr_img
                                                           location:nil
                                                        urlResource:urlsource
                                                presentedController:self.parentVC
                                                         completion:^(UMSocialResponseEntity *shareResponse){
                                                             if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                                                                 [self dismiss];
                                                                 [Utils postMessage:@"分享成功" onView:nil];
                                                             } else if (shareResponse.responseCode == UMSResponseCodeCancel) {
                                                                 [Utils postMessage:@"分享已取消" onView:nil];
                                                             } else {
                                                                 [Utils postMessage:@"分享失败" onView:nil];
                                                             }
                                                         }];
        
        
    }else{
        [UMSocialData defaultData].extConfig.title = self.model.title;

        if(platform == UMShareToSina){

            if (self.model.scr_img) {
                [UMSocialData defaultData].extConfig.sinaData.shareImage = self.model.scr_img;
            }
            [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@  %@", self.model.shareContent,endString];
        }else{
       
           
            if (self.model.scr_img) {
                 [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
                [UMSocialData defaultData].extConfig.wechatSessionData.shareImage =  self.model.scr_img;
                [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage =  self.model.scr_img;
            }else{
                 [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb&UMSocialWXMessageTypeText;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.model.url;
                [UMSocialData defaultData].extConfig.wechatSessionData.url = self.model.url;
            }
        }
        
        [UMSocialData openLog:YES];
        [self dismiss];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[platform]
                                                            content:self.model.shareContent
                                                              image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.img]]]
                                                           location:nil
                                                        urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                                     endString]
                                                presentedController:self.parentVC
                                                         completion:^(UMSocialResponseEntity *shareResponse){
                                                             if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                                                                 [Utils postMessage:@"分享成功" onView:nil];
                                                                 
                                                             } else if (shareResponse.responseCode == UMSResponseCodeCancel) {
                                                                 [Utils postMessage:@"分享已取消" onView:nil];
                                                                 
                                                                 
                                                             } else {
                                                                 [Utils postMessage:@"分享失败" onView:nil];
                                                                 
                                                             }
                                                         }];
    }
    
}

#pragma mark - Public Methods
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.contentView.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.bottom = self.height;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.top = self.height;
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
    
}

#pragma mark - Properties
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIView *)dividerLineView {
    if (!_dividerLineView) {
        _dividerLineView = [[UIView alloc] init];
        _dividerLineView.backgroundColor = DividerGrayColor;
    }
    return _dividerLineView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = [UIColor whiteColor];
        [_closeButton setImage:[UIImage imageNamed:@"share_close"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ShareItemView ()<UMSocialUIDelegate>

@property (nonatomic, strong) UIButton *iconButton;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, copy) NSString *platform;

@end

@implementation ShareItemView

- (id)initWithIcon:(UIImage *)iconImage name:(NSString *)name platform:(NSString *)platform {
    if (self = [super init]) {
        
        [self.iconButton setImage:iconImage forState:UIControlStateNormal];
        [self.iconButton addTarget:self action:@selector(iconButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.nameLabel.text = name;
        [self.nameLabel sizeToFit];
        self.platform = platform;
        
        [self addSubview:self.iconButton];
        [self addSubview:self.nameLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconButton.frame = CGRectMake(0, 0, self.width, self.width);
    self.nameLabel.top = self.iconButton.bottom;
    self.nameLabel.centerX = 0.5*self.width;
    
}

#pragma mark - Events
- (void)iconButtonClicked:(id)sender {
    if (self.shareBlock) {
        self.shareBlock(self.platform);
    }
}

#pragma mark - Properties
- (UIButton *)iconButton {
    if (!_iconButton) {
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.backgroundColor = [UIColor clearColor];
    }
    return _iconButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = GeneralLabelA(Font(12), TextColor2, NSTextAlignmentCenter);
    }
    return _nameLabel;
}


@end
