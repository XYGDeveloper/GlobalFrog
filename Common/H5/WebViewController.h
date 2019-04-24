//
//  WebViewController.h
//  Qqw
//
//  Created by zagger on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

#define H5URL(relativePath) [WebViewController urlStringWithRelativePath:relativePath]
@interface WebViewController : UIViewController<UIWebViewDelegate>{
    NSString * _shardUrl;
}

@property (nonatomic, strong) UIWebView *myWebView;

@property (nonatomic, copy, readonly) NSString *requestURLString;
/**
 *  是否使用h5页面的title，默认为NO
 */
@property (nonatomic, assign) BOOL useHtmlTitle;
/**
 *  在新的页面打开跳转的URL，默认为YES
 */
@property (nonatomic, assign) BOOL openURLInNewController;

/**
 *  是否需要下拉刷新，默认为NO
 */
@property (nonatomic, assign) BOOL shoulPullToRefresh;

- (id)initWithURLString:(NSString *)urlString;

+ (NSString *)urlStringWithRelativePath:(NSString *)relativePath;


@end


