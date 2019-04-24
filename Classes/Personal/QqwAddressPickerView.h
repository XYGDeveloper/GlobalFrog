//
//  QqwAddressPickerView.h
//  Qqw
//
//  Created by elink on 16/7/26.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^addressSelectBlock)(NSString* result);

@interface QqwAddressPickerView : NSObject

+(QqwAddressPickerView*)showAddressPickerViewOn:(id)view SelectedResult:(addressSelectBlock)select;
-(void)show;
@end
