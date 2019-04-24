//
//  LocationAddressView.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/6.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)();
@interface LocationAddressView : UIView{
    ClickBlock clickBlock;
}

@property(nonatomic,strong) UILabel * addressLabel;

- (instancetype)initWithFrame:(CGRect)frame block:(ClickBlock)block;


- (instancetype)initSearchWithFrame:(CGRect)frame block:(ClickBlock)block;

@end
