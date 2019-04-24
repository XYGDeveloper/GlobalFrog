//
//  AddressPicker.h
//  Qqw
//
//  Created by zagger on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"

@interface AddressPicker : NSObject

+ (void)showOnView:(UIView *)parentView withSelectBlock:(void(^)(AddressModel *address))selectBlock;

@end
