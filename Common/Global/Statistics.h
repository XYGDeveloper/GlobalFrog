//
//  Statistics.h
//  Qqw
//
//  Created by zagger on 16/9/5.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#ifndef Statistics_h
#define Statistics_h

#pragma mark - 事件统计
//①登录注册转化
//注册→获取验证码→完成注册 event_zhuce1→event_zhuce2→event_zhuce3
//微信→获取验证码→完成绑定 event_denglu1→event_denglu2→event_denglu3
static NSString *const kEventRegister = @"event_zhuce1";
static NSString *const kEventRegisterGetVerifyCode = @"event_zhuce2";
static NSString *const kEventRegisterFinished = @"event_zhuce3";

static NSString *const kEventWXLogin = @"event_denglu1";
static NSString *const kEventWXLoginGetVerifyCode = @"event_denglu2";
static NSString *const kEventWXLoginFinishBind = @"event_denglu3";

//②订单转化
//购物车→成为会员→选择管家→确认订单→支付成功
//event_dingdan1→event_dingdan2→event_dingdan3→event_dingdan4→event_dingdan6
static NSString *const kEventOrderSettle = @"event_dingdan1";//
static NSString *const kEventOrderBecomeVip = @"event_dingdan2";//
static NSString *const kEventOrderChooseSteward = @"event_dingdan3";//
static NSString *const kEventOrderConfirm = @"event_dingdan4";//
static NSString *const kEventOrderPay = @"event_dingdan6";

//③品牌直供路径转化
//首页→品牌直供→品牌文章列表页→品牌商品列表页→商品详情
//event_pinpai1→event_pinpai2→event_pinpai3→event_pinpai4→event_pinpai5
static NSString *const kEventHomepage = @"event_pinpai1";
static NSString *const kEventBrand = @"event_pinpai2";//品牌直供
static NSString *const kEventBrandArticleList = @"event_pinpai3";
static NSString *const kEventBrandGoodsList = @"event_pinpai4";
static NSString *const kEventBrandGoodsDetail = @"event_pinpai5";


//④商品分类路径转化
//商品分类页→商品分类列表页→商品详情页
//event_fenlei1→event_fenlei2→event_fenlei3
static NSString *const kEventSortHomepage = @"event_fenlei1";
static NSString *const kEventSortListPage = @"event_fenlei2";
static NSString *const kEventSortGoodsDetailPage = @"event_fenlei2";



#endif /* Statistics_h */
