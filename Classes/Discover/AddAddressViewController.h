//
//  AddAddressViewController.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/6.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
#import <AMapSearchKit/AMapSearchKit.h>
typedef NS_ENUM(NSUInteger, FreshAddressType) {
    FreshAddressType_update = 3,
    FreshAddressType_Add
    
};
@interface AddAddressViewController : UITableViewController

//@property(nonatomic,strong)  NSString * loctionAddress;

@property(nonatomic,strong)  CLLocation *currentLocation;

@property(nonatomic,assign) FreshAddressType freshAddressType;

@property(nonatomic,strong)  AddressModel * addressInfo;

@end
