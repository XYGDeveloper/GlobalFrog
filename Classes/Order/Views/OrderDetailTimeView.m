//
//  OrderDetailTimeView.m
//  Qqw
//
//  Created by zagger on 16/8/22.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderDetailTimeView.h"
#import "OrderModel.h"

@interface OrderDetailTimeView ()

@property (nonatomic, strong) UILabel *orderNumberLabel;

@end

@implementation OrderDetailTimeView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


#pragma mark - Public Methods
- (void)refreshWithOrder:(OrderModel *)order {
    NSMutableArray *subArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单编号：%@",order.order_sn];
    [subArray safeAddObject:self.orderNumberLabel];
    
    if ([self valideTimeString:order.create_time]) {
        UILabel *createLabel = GeneralLabel(Font(13), TextColor2);
        NSString *timeStr = [NSDate fullTimeStringWithInterval:order.create_time.doubleValue];
        createLabel.text = [NSString stringWithFormat:@"下单时间：%@",timeStr];
        [subArray safeAddObject:createLabel];
    }
    
    if ([self valideTimeString:order.pay_time]) {
        UILabel *payLabel = GeneralLabel(Font(13), TextColor2);
        NSString *timeStr = [NSDate fullTimeStringWithInterval:order.pay_time.doubleValue];
        payLabel.text = [NSString stringWithFormat:@"付款时间：%@",timeStr];
        [subArray safeAddObject:payLabel];
    }
    
    if ([self valideTimeString:order.shipping_time]) {
        UILabel *shipLabel = GeneralLabel(Font(13), TextColor2);
        NSString *timeStr = [NSDate fullTimeStringWithInterval:order.shipping_time.doubleValue];
        shipLabel.text = [NSString stringWithFormat:@"发货时间：%@",timeStr];
        [subArray safeAddObject:shipLabel];
    }
    
    if ([self valideTimeString:order.receipt_time]) {
        UILabel *confirmLabel = GeneralLabel(Font(13), TextColor2);
        NSString *timeStr = [NSDate fullTimeStringWithInterval:order.receipt_time.doubleValue];
        confirmLabel.text = [NSString stringWithFormat:@"收货时间：%@",timeStr];
        [subArray safeAddObject:confirmLabel];
    }
    
    [self reLayoutWithSubViews:subArray];
}

-(BOOL)valideTimeString:(NSString *)timeString {
    if (!timeString || timeString.length <= 0 || [timeString isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}


#pragma mark - Layout
- (void)reLayoutWithSubViews:(NSArray *)subArray {
    [self removeAllSubViews];
    
    UILabel *tempLabel = nil;
    for (int i = 0; i < subArray.count; i++) {
        UILabel *label = [subArray safeObjectAtIndex:i];
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            
            if (tempLabel) {
                make.top.equalTo(tempLabel.mas_bottom).offset(7);
            } else {
                make.top.equalTo(@12);
            }
            
            if (i == subArray.count - 1) {
                make.bottom.equalTo(self).offset(-12);
            }
        }];
        
        tempLabel = label;
    }
}


#pragma mark - Properties
- (UILabel *)orderNumberLabel {
    if (!_orderNumberLabel) {
        _orderNumberLabel = GeneralLabel(Font(13), TextColor2);
    }
    return _orderNumberLabel;
}

@end
