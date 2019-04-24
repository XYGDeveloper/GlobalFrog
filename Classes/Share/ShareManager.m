//
//  ShareManager.m
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "ShareManager.h"
#import "ShareView.h"
#import "ShareApi.h"

@interface ShareManager ()<ApiRequestDelegate>

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, strong) ShareApi *api;

@end

@implementation ShareManager

+ (void)shareWithUrl:(NSString*)url  img:(UIImage*)img viewController:(UIViewController *)viewController{
    ShareModel *model = [ShareModel new];
    model.url = url;
    model.scr_img = img;
    model.content = @"";
    [ShareView showShareViewWithModel:model InViewController:viewController];

}

+ (void)shareWithType:(NSString *)type identifier:(NSString *)identifier inViewController:(UIViewController *)viewController {
    [ShareManager defaultManager].viewController = viewController;
    
    [Utils addHudOnView:viewController.view];
    
    [[ShareManager defaultManager].api getShareInfoWithType:type shareTo:@"WEIXIN" identifier:identifier];
    
}

+ (instancetype)defaultManager {
    static ShareManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[ShareManager alloc] init];
    });
    return __manager;
}

#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    
    [Utils removeHudFromView:self.viewController.view];
    [ShareView showShareViewWithModel:responsObject InViewController:self.viewController];
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils removeHudFromView:self.viewController.view];
    [Utils postMessage:command.response.msg onView:self.viewController.view];
}

#pragma mark - Properties
- (ShareApi *)api {
    if (!_api) {
        _api = [[ShareApi alloc] init];
        _api.delegate = self;
    }
    return _api;
}

@end
