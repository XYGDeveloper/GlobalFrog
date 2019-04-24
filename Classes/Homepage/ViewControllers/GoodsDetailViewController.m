//
//  GoodsDetailViewController.m
//  Qqw
//
//  Created by zagger on 16/8/26.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "ShareManager.h"

@interface GoodsDetailViewController ()<UIScrollViewDelegate>


@end

@implementation GoodsDetailViewController

- (id)initWithGoodsIdentifier:(NSString *)goodsId {
    NSString *relativePath = [NSString stringWithFormat:@"/app-goods/detail?id=%@", goodsId];
    if (self = [super initWithURLString:H5URL(relativePath)]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPage:) name:krefreshCartNotify object:nil];
        //滑动到低端禁止滑动
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollViewStateChange:) name:kScrollTobottomNotify object:nil];
        
        self.myWebView.scrollView.delegate = self;
        
    }
    return self;
}

- (void)refreshPage:(NSNotification *)noti{
    
    if ([noti.name isEqualToString:krefreshCartNotify]) {
        
        [self.myWebView reload];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

    if (self.eventStatisticsId) {
        [MobClick event:self.eventStatisticsId];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
    
}


//此方法用于解决：当webview滑动到底时，webview的滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((scrollView.contentSize.height - scrollView.contentOffset.y) == scrollView.frame.size.height) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kScrollTobottomNotify object:nil];
    }
}

- (void)scrollViewStateChange:(NSNotification *)niti{
    if ([niti.name isEqualToString:kScrollTobottomNotify]) {
        self.myWebView.scrollView.bounces = NO;
    }
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
}




- (void)dealloc
{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}


@end
