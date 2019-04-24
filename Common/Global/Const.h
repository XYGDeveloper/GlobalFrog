//
//  Const.h
//  Qqw
//
//  Created by zagger on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#ifndef Const_h
#define Const_h

#pragma mark - 公司相关
static NSString *const kServicePhoneNumber = @"400-6516-838";//公司服务电话
static NSString *const kAppDownloadUrl = @"https://itunes.apple.com/us/app/quan-qiu-wa/id1141650448?l=zh&ls=1&mt=8";
#pragma mark- 极光推送参数
static NSString *const kOpenAppliacation = @"1";//用来打开应用程序
static NSString *const kjumpWithWebPage = @"2";//用来跳转到相应的链接

#pragma mark - 第三方平台账号
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static NSString *const kUMengAppKey = @"507fcab25270157b37000010";
static NSString *const kUmengStatic = @"57a5a87767e58ecb8b0015b4";

//bugly
static NSString *const kBuglyAppId = @"900045770";
static NSString *const kBuglyAppKey = @"LFiYm6Dc8n0KI5Yt";

//微信
static NSString *const kWechatAppId = @"wx03fd1ec32a0c67dc";
static NSString *const kWechatAppSecret = @"8f77b6885bdcc81649d8268b852884f8";

//QQ
static NSString *const kQQAppId = @"1105009984";
static NSString *const kQQAppSecret = @"lpKOmhEt6wbB5jXC";

//sina weibo
static NSString *const kSinaAppId = @"3354868272";
static NSString *const kSinaAppSecret = @"ff65c13485859d7cceeb746b15bd21b4";
//极光推送相关参数
static NSString *const kAppKey  = @"33a3a8831e098806c380af34";
static NSString *const channel = @"App Store";

#define GDMAP_KEY @"2d94fa8c7470127720531215889bf2ca"

//激光证书环境配置（开发环境为---false，生产环境为----yes）
static BOOL isProduction = false;
#pragma mark - api及h5地址域名
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//static NSString *const kApiDomain = @"http://api.beta.quanqiuwa.com";
//static NSString *const kH5Domain = @"http://m.beta.quanqiuwa.com";
static NSString *const kApiDomain = @"http://api.quanqiuwa.com";
static NSString *const kH5Domain = @"http://m.quanqiuwa.com";
#pragma mark - 本地支付结果状态
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static NSString *const PayResultTypeSuccess = @"success";
static NSString *const PayResultTypeFailed = @"failure";
static NSString *const PayResultTypeCancel = @"cancel";
typedef void(^LocalPayResultBlock)(NSString *result);

#pragma mark - 订单状态
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//请求订单列表时状态区分 1-全部订单 2-待付款 3-待发货 4-待收货 5-待评价
static NSString *const OrderReqStatusAll = @"1";
static NSString *const OrderReqStatusWaitPay = @"2";
static NSString *const OrderReqStatusWaitSend = @"3";
static NSString *const OrderReqStatusWaitRecieve = @"4";
static NSString *const OrderReqStatusWaitComment = @"5";
#pragma mark - 订单类型
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//0:普通，8:众筹
typedef NS_ENUM(NSInteger, OrderType) {
    OrderTypeNormal = 0,
    orderTypeCrowdfunding = 8
};
#pragma mark - 全局通知
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static NSString *const kLoginSuccessNotify = @"kLoginSuccessNotify"; //登陆成功通知
static NSString *const kLogoutSuccessNotify = @"kLogoutSuccessNotify"; //退出登陆成功通知
static NSString *const kModifyPasswordSuccessNotify = @"kModifyPasswordSuccessNotify";//密码修改成功通知
static NSString *const kOrderCreateSuccessNotify = @"kOrderCreateSuccessNotify"; //订单创建成功、刷新购物车等
static NSString *const kOrderPaySuccessNotify = @"kOrderPaySuccessNotify"; //订单支付成功
static NSString *const kRewardSuccessNotify = @"kRewardSuccessNotify";//打赏成功
//对订单进行，评价、取消、删除、确认收货等操作后，订单状态发生变时，发送该通知
static NSString *const kOrderStatusChangedNotify = @"kOrderStatusChangedNotify";
static NSString *const kAddToCartSuccessNotify = @"kAddToCartSuccessNotify";//添加商品到购物车成功
static NSString *const kJumpToOrderListPageNotify = @"kJumpToOrderListPageNotify"; //跳转到订单列表
static NSString *const kJumpToOrderDetailPageNotify = @"kJumpToOrderDetailPageNotify"; //跳转到订单详情页，通知参数带订单信息
static NSString *const krefreshHomePageNotify = @"krefreshHomePageNotify"; //刷新首页
static NSString *const krefreshCartNotify = @"krefreshDetailPageNotify"; //刷新商品详情页
static NSString *const kScrollTobottomNotify = @"kScrollTobottomNotify"; 
static NSString *const kCounttimeEndRefreshList = @"kCounttimeEndRefreshList"; //跳转到订单列表
static NSString *const kPauseCountRobot = @"kPauseCountRobot";    //操作计时器






#endif /* Const_h */
