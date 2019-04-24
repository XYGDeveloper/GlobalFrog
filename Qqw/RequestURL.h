//
//  RequestURL.h
//  Qqw
//
//  Created by 全球蛙 on 2017/2/22.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#ifndef RequestURL_h
#define RequestURL_h

//static NSString * const LogIn_url =kApiDomain stringByAppendingString:<#(nonnull NSString *)#>;
#define LOGIN_URL  [kApiDomain stringByAppendingString:@"/user-main/login"]  //登录
#define REGISTER_URL  [kApiDomain stringByAppendingString:@"/user-main/register"]  //注册
#define CHANGE_PWD_URL  [kApiDomain stringByAppendingString:@"/user-main/changepass"]  //修改密码


#define BIND_USER_URL  [kApiDomain stringByAppendingString:@"/user-main/bindThird"]  //绑定第三方
#define USER_INFO_URL  [kApiDomain stringByAppendingString:@"/user-main/profile"]  //获取用户信息

#define THIRD_LOGIN_URL  [kApiDomain stringByAppendingString:@"/user-main/third"]  //第三方登录

#define CHANGE_USER_INFO_URL  [kApiDomain stringByAppendingString:@"/user-main/profile"]  //修改用户信息
#define SEND_CODE_URL  [kApiDomain stringByAppendingString:@"/user-main/sendSms"]  //获取注册验证码

#define FIND_CODE_URL  [kApiDomain stringByAppendingString:@"/user-main/checkCode"]  //验证找回密码验证码
#define FIND_PWD_URL  [kApiDomain stringByAppendingString:@"/user-main/rePasswd"]  //找回密码
#define SEND_FIND_PWD_URL  [kApiDomain stringByAppendingString:@"/user-main/sendPasswdSms"]  //发送找回密码验证码

#define CONFIRM_URL  [kApiDomain stringByAppendingString:@"/user-order/confirm"]  //确认订单
#define CREATE_ORDE_URL  [kApiDomain stringByAppendingString:@"/user-order/create"]  //创建订单
#define ORDE_INFO_URL  [kApiDomain stringByAppendingString:@"/user-order/detail"]  //订单详情
#define DELT_ORDE_URL  [kApiDomain stringByAppendingString:@"/user-order/del"]  //删除订单
#define CANCEl_ORDE_URL  [kApiDomain stringByAppendingString:@"/user-order/cancel"]  //取消订单
#define DOGET_ORDE_URL  [kApiDomain stringByAppendingString:@"/user-order/doget"]  //确认订单
#define ORDER_LIST_URL  [kApiDomain stringByAppendingString:@"/user-order/list"]  //订单列表

//#define CONFIRM_URL  [kApiDomain stringByAppendingString:@"/user-order/create"]  //下订单

#define ATTENTION_URL  [kApiDomain stringByAppendingString:@"/user-follow/addFollow"]  //关注
#define UN_ATTENTION_URL  [kApiDomain stringByAppendingString:@"/user-follow/cancelFollow"]  //取消关注
#define ATTENTION_LIST_URL  [kApiDomain stringByAppendingString:@"/user-follow/followList"]  //已关注列表


#define ADDRESS_LIST_URL  [kApiDomain stringByAppendingString:@"/user-address/list"]  //地址列表
#define UPDATE_ADDRESS_URL  [kApiDomain stringByAppendingString:@"/user-address/update"]  //更新地址
#define DEL_ADDRESS_URL  [kApiDomain stringByAppendingString:@"/user-address/del"]  //删除地址
#define ADD_ADDRESS_URL  [kApiDomain stringByAppendingString:@"/user-address/add"]  //添加地址

#define UPDATA_FRESH_ADDRESS_URL  [kApiDomain stringByAppendingString:@"/user-address/updateFreshAddress"]  //蛙鲜生更新地址
#define ADD_FRESH_ADDRESS_URL  [kApiDomain stringByAppendingString:@"/user-address/addFreshAddress"]  //蛙鲜生添加地址

#define ALLTYPE_COUNT_URL  [kApiDomain stringByAppendingString:@"/user-order/getAllTypeCount"]  //状态个数

#define COUPON_LIST_URL  [kApiDomain stringByAppendingString:@"/user-order/couponList"] //优惠卷列表

#define ORDER_COMMENT_URL  [kApiDomain stringByAppendingString:@"/user-order/goodsComment"] //订单评价
#define USER_IDCARD_URL  [kApiDomain stringByAppendingString:@"/user-idcard/check"] //实名认证-判断是否需要实名认证
#define USER_ID_ADD_URL  [kApiDomain stringByAppendingString:@"/user-idcard/add"] //保税区-实名认证-添加实名认证
#define USER_ID_LIST_URL  [kApiDomain stringByAppendingString:@"/user-idcard/list"] //保税区-实名认证-列表
#define USER_ID_DEFAULT_URL  [kApiDomain stringByAppendingString:@"/user-idcard/setdefault"] //实名认证-设为默认
#define USER_ID_DET_URL  [kApiDomain stringByAppendingString:@"/user-idcard/del"] //实名认证-删除


#define MSG_CENTER_URL  [kApiDomain stringByAppendingString:@"/user-pm/msgCenter"] //消息中心
#define MSG_INDEX_URL  [kApiDomain stringByAppendingString:@"/user-pm/index"] //用户私信列表页
#define MSG_DETAIL_URL  [kApiDomain stringByAppendingString:@"/user-pm/detail"] //用户私信详情
#define MSG_SEND_URL  [kApiDomain stringByAppendingString:@"/user-pm/send"] //发送私信
#define MSG_LIST_URL  [kApiDomain stringByAppendingString:@"/user-message/index"] //系统消息列表

#define FEEDBACK_URL  [kApiDomain stringByAppendingString:@"/user-main/feedback"] //用户反馈
#define LOGOUT_URL  [kApiDomain stringByAppendingString:@"/user-main/logout"] //退出登陆

#define CART_LIST_URL  [kApiDomain stringByAppendingString:@"/user-cart/list"] // 购物车列表

#define CART_NEW_URL  [kApiDomain stringByAppendingString:@"/user-cart/listnew"] // (新)购物车列表
#define CART_UPDATE_URL  [kApiDomain stringByAppendingString:@"/user-cart/update"] // 更新购物车
#define CART_DEL_URL  [kApiDomain stringByAppendingString:@"/user-cart/del"] // 购物车批量删除


#define FAVORITE_URL  [kApiDomain stringByAppendingString:@"/goods-favorite/list"]  //收藏列表
#define DEL_FAVORITE_URL  [kApiDomain stringByAppendingString:@"/goods-favorite/del"]  //删除收藏
#define ADD_FAVORITE_URL  [kApiDomain stringByAppendingString:@"/goods-favorite/add"]  //添加收藏

#define GOODS_LIST_URL  [kApiDomain stringByAppendingString:@"/goods-main/list"] //分类下商品

#define VIP_URL  [kApiDomain stringByAppendingString:@"/butler-main/show"] //成为会员数据获取
#define VIP_JOIN_URL  [kApiDomain stringByAppendingString:@"/butler-main/joinUser"] //成为会员-提交数据


#define COMMENT_SAVE_URL  [kApiDomain stringByAppendingString:@"/butler-article/saveComment"] //保存评论
#define COMMENT_LIST_URL  [kApiDomain stringByAppendingString:@"/butler-article/commentList"] //获取评论列表


#define SHARE_URL  [kApiDomain stringByAppendingString:@"/share/get"] //分享信息

#define HOT_GOODS_URL  [kApiDomain stringByAppendingString:@"/search-main/hot"] //热门商品
#define SEARCH_GOODS_URL  [kApiDomain stringByAppendingString:@"/goods-main/search"] //搜索商品

#define PAY_INFO_URL  [kApiDomain stringByAppendingString:@"/payment-pay/paySubmit"] //支付信息



#endif /* RequestURL_h */











