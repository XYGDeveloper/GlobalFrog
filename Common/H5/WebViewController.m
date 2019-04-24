//
//  WebViewController.m
//  Qqw
//
//  Created by zagger on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//
#import "WebViewController.h"
#import "ShareManager.h"
#import "QQWRefreshHeader.h"
#import "AppDelegate.h"
#import "RootManager.h"
#import "OrderModel.h"
#import "CrowdfundingModel.h"
#import "OrderConfirmViewController.h"
#import "GoodsDetailViewController.h"
#import "TopicViewController.h"
#import "DoyenSubListViewController.h"
#import "SortContainerViewController.h"
#import "PayModeViewController.h"
#import "ShoppingViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "SuccessViewController.h"
#import <objc/runtime.h>
#import "TagViewController.h"
#import "LoginViewControll.h"
#import "MessageViewController.h"
#import "DistributeViewController.h"
#import "TalkViewController.h"
@interface WebViewController ()<NJKWebViewProgressDelegate,UIScrollViewDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    
}

@property (nonatomic, copy, readwrite) NSString *shareType;
@property (nonatomic, copy, readwrite) NSString *shareId;
@property (nonatomic, copy, readwrite) NSString *arcticle_id;
@property (nonatomic, copy, readwrite) NSString *requestURLString;
@property (nonatomic, copy, readwrite) JSContext *context;

@end

@implementation WebViewController
+ (NSString *)urlStringWithRelativePath:(NSString *)relativePath {
    if ([relativePath hasPrefix:@"/"]) {
        return [NSString stringWithFormat:@"%@%@",kH5Domain, relativePath];
    } else {
        return [NSString stringWithFormat:@"%@/%@",kH5Domain, relativePath];
    }
}

- (void)startRequestWithUrl:(NSString *)url {
    if (url) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        request.timeoutInterval = 30;
        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.myWebView loadRequest:request];
    }
}


#pragma mark ================== super =================

- (id)initWithURLString:(NSString *)urlString {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.requestURLString = urlString;
        self.openURLInNewController = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kLoginSuccessNotify object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kLogoutSuccessNotify object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh:) name:@"refresh" object:nil];
        
    }
    return self;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
    NSLog(@"%@",_requestURLString);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    //工厂直供点赞，专题精选点赞
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *article_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"article_id"];
        
        if (article_id) {
            NSString *func = [NSString stringWithFormat:@"refreshLike('%@')",article_id];
            [_context evaluateScript:func];
        }
        
    });
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
    
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
//    NSLog(@"%s,%@",__FUNCTION__,parent);
    if(!parent){
        
        [_myWebView removeFromSuperview];
        _myWebView = nil;
    }
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.myWebView removeFromSuperview];
    self.myWebView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self.view addSubview:self.myWebView];
    [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    if (self.requestURLString) {
        [self startRequestWithUrl:self.requestURLString];
    }
    
    //优化方案：webview进度条
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _myWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //打赏成功监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rewardChange:) name:kRewardSuccessNotify object:nil];
    
}



#pragma mark - Properties
- (UIWebView *)myWebView {
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _myWebView.backgroundColor = DefaultBackgroundColor;
        _myWebView.delegate = self;
        _myWebView.scalesPageToFit = YES;
        _myWebView.scrollView.showsHorizontalScrollIndicator = NO;
        _myWebView.scrollView.delegate = self;
    }
    return _myWebView;
}
#pragma mark ================== noti =================
- (void)rewardChange:(NSNotification *)noti{
    if ([noti.name isEqualToString:kRewardSuccessNotify]) {
        [self.myWebView reload];
    }
}

- (void)refresh:(NSNotification *)noti{
    
    if ([noti.name isEqualToString:@"refresh"]) {
        
        [self.myWebView reload];
        
    }
}

- (void)notificationRecieved:(NSNotification *)note {
    [self.myWebView reload];
}



#pragma mark - left NavigationItem
- (void)setNormalBackItem {
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"nav_back"] highligthtedImage:nil action:@selector(popButtonClicked:)];
}

- (void)setMultiBackItem {
    UIButton *backButton = [self navigationButtonWithImage:[UIImage imageNamed:@"nav_back"] highligthtedImage:nil action:@selector(popButtonClicked:)];
    UIButton *closeButton = [self navigationButtonWithTitle:@"关闭" action:@selector(closeButtonClicked:)];
    [self setLeftNavigationItems:@[backButton, closeButton]];
}

- (void)configReturnButton {
    if (self.navigationController.viewControllers.count > 1 && self.myWebView.canGoBack) {
        [self setMultiBackItem];
    } else if (self.navigationController.viewControllers.count <= 1 && !self.myWebView.canGoBack) {
        [self setLeftNavigationItemWithTitle:@"" action:nil];
    } else {
        
        [self setNormalBackItem];
        
    }
}

- (void)closeButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popButtonClicked:(id)sender {
    if (self.myWebView.canGoBack) {
        [self.myWebView goBack];
        self.navigationItem.rightBarButtonItems = nil;
    } else if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
      
    }
}
#pragma mark ================== gogo =================
//去支持，即众众筹下单
- (void)supportWithCrowdfunding:(NSString *)cf_id sku:(NSString *)sku_id byCount:(NSString *)buyCount {
    CrowdfundingModel *cfModel = [[CrowdfundingModel alloc] init];
    cfModel.cf_id = cf_id;
    cfModel.sku_id = sku_id;
    cfModel.cf_num = buyCount;
    OrderConfirmViewController *vc = [[OrderConfirmViewController alloc] init];
    vc.oType = orderTypeCrowdfunding;
    vc.crowdfundingArray = @[cfModel];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)payWithOrder:(NSString *)orderId amount:(NSString *)orderAmount {
    OrderModel *model = [[OrderModel alloc] init];
    model.order_sn = orderId;
    model.order_amount = orderAmount;
    PayModeViewController *vc = [[PayModeViewController alloc] initWithOrder:model];
    vc.shouldJumpToSuccessPage = NO;
    vc.paySuccessJumpViewController = self.navigationController.topViewController;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)share {
    [ShareManager shareWithType:self.shareType identifier:self.shareId inViewController:self];
}

-(void)share2{
    UIImage * img = [self screenView:self.myWebView.scrollView];
    [ShareManager shareWithUrl:_shardUrl img:img viewController:self];
}

- (UIImage*)screenView:(UIScrollView *)view{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.myWebView.width,view.frame.size.height), YES, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    
    return sendImage;
}

#pragma mark =========================================================================================================
- (BOOL)isJavascriptParameterValid:(NSString *)jsParam {
    if (!jsParam ||
        ![jsParam isKindOfClass:[NSString class]] ||
        jsParam.length <= 0 ||
        [jsParam isEqualToString:@"undefined"]) {
        
        return NO;
        
    }
    return YES;
}
#pragma mark - 配置js交互
- (void)addJSMethodsWithContext:(JSContext *)context {
    weakify(self);
    //打印异常信息
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"报异常信息： --- %@",exceptionValue);
    };
    NSLog(@"%@",context[@"share"] );
    context[@"console.log"] = ^{
        NSLog(@"asfasfasf");
    };
    //跳转到新的H5页面
    context[@"redirectTo"] = ^(NSString *urlString) {
        strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            WebViewController *vc = [[WebViewController alloc] initWithURLString:urlString];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        });
    };
    //返回
    context[@"back"] = ^{
        dispatch_async(dispatch_get_main_queue(), ^{

          [self.navigationController popViewControllerAnimated:YES];
            
        });
    };
    
    //添加下拉刷新
    context[@"addPullToRefersh"] = ^ {
        strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shoulPullToRefresh = YES;
        });
    };
    
    //去登陆
    context[@"login"] = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utils showLoginPageIfNeeded];
        });
    };
    
    //分享
    context[@"share"] = ^(NSString *shareId, NSString *shareType) {
        strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"%@,%@",shareId,shareType);
        if (![shareType isEqualToString:@"6"]) {
            
            [self setRightNavigationItemWithImage:[UIImage imageNamed:@"nav_share"] highligthtedImage:nil action:@selector(share)];
            self.shareType = shareType;
            self.shareId = shareId;
          
        }else{
                
            [ShareManager shareWithType:@"6" identifier:shareId inViewController:self];
        }
            
        });
       
    };
    
    //截图分享
    _shardUrl = nil;
    context[@"showCapture"] = ^(NSString *url) {
        NSLog(@"%@",url);
        dispatch_async(dispatch_get_main_queue(), ^{
            _shardUrl = url;
            [self setRightNavigationItemWithImage:[UIImage imageNamed:@"nav_share"] highligthtedImage:nil action:@selector(share2)];
            
        });
    };
    
    //事件统计
    context[@"event"] = ^(NSString *eventId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MobClick event:eventId];
        });
    };
    
    //众筹详情去支持
    context[@"toSupport"] = ^(NSString *cf_id, NSString *sku_id, NSString *goods_number) {
        strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self supportWithCrowdfunding:cf_id sku:sku_id byCount:goods_number];
        });
    };
    
    //跳转到购物车
    context[@"toShopCart"] = ^{
        strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ShoppingViewController *shop = [ShoppingViewController new];
            shop.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shop animated:YES];
            
        });
    };
    
    //跳转到达人推荐
    context[@"toDoyen"] = ^(NSString *identifier, NSString *name){
        strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self isJavascriptParameterValid:identifier] && [self isJavascriptParameterValid:name]) {
                DoyenSubListViewController *vc = [[DoyenSubListViewController alloc] init];
                vc.doyen_type = identifier;
                vc.title = name;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [Utils jumpToTabbarControllerAtIndex:1];
            }
            
        });
    };
    
    //跳转到精选专题
    context[@"toArtSpecial"] = ^{
        strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            TopicViewController *vc =[[TopicViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        });
    };
    
    //跳转到商品分类
    context[@"toCategory"] = ^{
        strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            SortContainerViewController *vc =[[SortContainerViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        });
    };
    
    //文章打赏
    context[@"reward"] = ^(NSString *order_sn, NSString *order_price) {
        strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@,%@",order_sn,order_price);
            [self payWithOrder:order_sn amount:order_price];
        });
    };
    
    //拨打电话
    context[@"callPhone"] = ^(NSString *phoneNumber) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utils callPhoneNumber:phoneNumber];
        });
    };
    
    //将电话添加到通讯录
    context[@"addToAddressBook"] = ^(NSString *phoneNumber) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utils addPhoneNumberToAddressBook:phoneNumber];
        });
    };
    
    //添加商品到购物车成功
    context[@"cartChanged"] = ^ {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddToCartSuccessNotify object:nil];
    };
    
    //从引导页进入首页
    context[@"jumpToHomepage"] = ^ {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utils updateCachedAppVersion];

            NSString * isFist = [[NSUserDefaults standardUserDefaults] objectForKey:@"__TAG"];
            if (isFist ) {
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.window.rootViewController = [RootManager sharedManager].tabbarController;
            }else{
                TagViewController *tag = [TagViewController new];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.window.rootViewController = tag;
            }
        });
    };
    
    //从标签页进入首页
    context[@"selectedTag"] = ^(NSString *str){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"__TAG"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [Utils updateCachedAppVersion];
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = [RootManager sharedManager].tabbarController;
            
        });
    };

    //点赞或取消点赞
    context[@"likeEvent"] = ^(NSString *article_id) {
        strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"文章详情点赞：%@",article_id);
            self.arcticle_id = article_id;
            [[NSUserDefaults standardUserDefaults]setObject:article_id forKey:@"article_id"];
            
        });
        
    };
    
    
    //跳转到 选择定位地址页面
    context[@"toLocationSelect"] = ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_Fresh_SelectAddress object:nil];
    };
    
    //发送私信
    context[@"sendPrivateMsg"] = ^(NSString *uid, NSString *uname) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([Utils showLoginPageIfNeeded]) {
                
            } else {
                
                MessageViewController *messagedetail = [MessageViewController new];
                messagedetail.title = [NSString stringWithFormat:@"与%@私聊",uname];
                messagedetail.uid = uid;
                messagedetail.id = 0;
                NSLog(@"---%@,-----%@",uid,uname);
                [self.navigationController pushViewController:messagedetail animated:YES];
            }
        });
        
    };
    
    //晒一晒
    
    context[@"toShow"] = ^(NSString *id) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if ([Utils showLoginPageIfNeeded]) {
                
                
            } else {
                
                DistributeViewController *distriBute = [DistributeViewController new];
                
                distriBute.title = @"发布话题";
                
                distriBute.tid = id;
                
                NSLog(@"---%@",id);
                
                [self.navigationController pushViewController:distriBute animated:YES];
                
            }
            
        });
        
    };
    
    
    //说一说
    
    context[@"toSay"] = ^(NSString *id) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if ([Utils showLoginPageIfNeeded]) {
                
                
            } else {
                
                TalkViewController *talk = [TalkViewController new];
                
                talk.title = @"发布话题";
                
                talk.cid = id;
                
                NSLog(@"---%@",id);
                
                [self.navigationController pushViewController:talk animated:YES];
                
            }
            
        });
        
    };
    //关注
    context[@"sendFocusState"] = ^(NSString *uids,  NSString * state, NSString * count) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"我点了关注+++++++++++++  %@  %@   %@",uids,state,count);
            NSString * s  = [NSString stringWithFormat:@"%@,%@,%@",uids,state,count];
            [[NSNotificationCenter defaultCenter]postNotificationName:KNOTIFY_CHANGE_HT5_REFRESH object:s];
        });
        
    };

    
}



- (void)backRewardPageAndRefresh
{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.myWebView reload];
    
}

#pragma mark - Events


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.myWebView.scrollView.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    //禁止在web上进行乱七八糟的操作
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    if (self.useHtmlTitle) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        });
    }
    
    //配置返回按钮
    if (!self.openURLInNewController) {
        [self configReturnButton];
    }
    
    //配置js交互
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //工厂直供点赞
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"报异常信息： --- %@",exceptionValue);
    };
    
    //品牌制造商收藏
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"goodsid"]) {
        NSString *funCollect =  [NSString stringWithFormat:@"refreshCollect('%@')",[[NSUserDefaults standardUserDefaults] objectForKey:@"goodsid"]];
        [self.context evaluateScript:funCollect];
        
    }
    
    [self addJSMethodsWithContext:context];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.myWebView.scrollView.mj_header endRefreshing];
    [self configReturnButton];
    NSLog(@"%li",(long)error.code);
    if (error.code == -1009) {
        [[EmptyManager sharedManager] showNetErrorOnView:self.view response:nil operationBlock:^{
            [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestURLString]]];
            
        }];
        return;
    }
    if ([error.domain isEqualToString:@"NSURLErrorDomain"] || [error.domain isEqualToString:@"WebKitErrorDomain"] ) {
        if (error.code == NSURLErrorCancelled || error.code == 102 || error.code == 204 || error.code == 101) {
            return;
        }
    }
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString * tmpStr = [request.URL.absoluteString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSLog(@"web type = %li    %@",(long)navigationType  ,self.requestURLString);
    NSLog(@"-----%@",tmpStr);
    if ( !self.openURLInNewController ||[tmpStr isEqualToString:self.requestURLString]||[tmpStr rangeOfString:@"http"].location == NSNotFound) {
        [Utils addCookiesForURL:request.URL];
    }else{
        WebViewController *vc = [[WebViewController alloc] initWithURLString:request.URL.absoluteString];
        vc.useHtmlTitle = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
        
    }
    
    return YES;
    
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
}


@end
