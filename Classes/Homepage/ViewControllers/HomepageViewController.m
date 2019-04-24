//
//  HomepageViewController.m
//  Qqw
//
//  Created by zagger on 16/8/25.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "HomepageViewController.h"
#import "SearchViewController.h"
#import "GoodsDetailViewController.h"

@interface HomepageViewController ()<UIScrollViewDelegate>{

}

@property (nonatomic, copy, readwrite) JSContext *context;

@end

@implementation HomepageViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kLoginSuccessNotify object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kLogoutSuccessNotify object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshHomePage:) name:krefreshHomePageNotify object:nil];
      
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithImage:[UIImage imageNamed:@"login_logo"]];
    [self setRightNavigationItemWithImage:[UIImage imageNamed:@"nav_search"] highligthtedImage:nil action:@selector(searchButtonClicked:)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMy:) name:KNOTIFY_CHANGE_HT5_REFRESH object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *article_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"article_id"];
        if (article_id) {
            NSString *func = [NSString stringWithFormat:@"refreshLike('%@')",article_id];
            [_context evaluateScript:func];
        }
    });

    self.myWebView.scrollView.mj_header =  [QQWRefreshHeader headerWithRefreshingBlock:^{
         [self loadRequest];
    }];
}

#pragma mark - Events
- (void)searchButtonClicked:(id)sender {
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.searchType = SearchType_qqw;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ================== noty =================
-(void)refreshMy:(NSNotification*)noty{
    NSLog(@"%@",noty.object);
//    NSString * s = noty.object;
//    NSArray * a = [s componentsSeparatedByString:@","];
//    JSValue *Callback = self.context[@"nativeChangeFocus"];
//    [Callback callWithArguments:@[a[0],a[1],a[2]]];
}

- (void)notificationRecieved:(NSNotification *)note {
    if ([note.name isEqualToString:kLoginSuccessNotify] || [note.name isEqualToString:kLogoutSuccessNotify]) {
        [self loadRequest];
    }
}

- (void)refreshHomePage:(NSNotification *)noti{
    if ([noti.name isEqualToString:krefreshHomePageNotify]) {
        [self.myWebView reload];
    }
}

#pragma mark - Properties
- (NSString *)requestURLString {
    return H5_MAIN_URL;
}
-(void)loadRequest{
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5_MAIN_URL]]];
}

#pragma mark ================== webView delegate =================
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    [self.myWebView.scrollView.mj_header endRefreshing];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [super webView:webView didFailLoadWithError:error];
  
}

#pragma mark ================== super =================
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick event:kEventHomepage];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
