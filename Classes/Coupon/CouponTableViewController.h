//
//  CouponTableViewController.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/15.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ConponModel.h"
@class ConponModel;
typedef NS_ENUM(NSInteger, CouponType) {
    CouponType_Unused = 0, //未使用
    CouponType_Used,
    CouponType_expired ,
};

@interface CouponTableViewController : UITableViewController

@property(nonatomic,assign) CouponType conponType;

@property(nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic, copy) void(^selectUseConpon)(ConponModel *model);



@end
