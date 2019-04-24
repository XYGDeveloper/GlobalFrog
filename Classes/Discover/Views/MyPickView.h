//
//  MyPickView.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/6.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//
#import "ShowTimeInfo.h"
#import <UIKit/UIKit.h>

typedef void(^SelectPickViewBlock)(NSString * str);
@interface MyPickView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSArray * _dataArray;
    NSString * _selectString;
     SelectPickViewBlock clickBlock;
    NSMutableDictionary * _dataSource;
    
    
    NSString * selectStr1;
    NSString * selectStr2;
}

@property(nonatomic,strong) UIPickerView * pickerView;

@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *times;
@property (nonatomic, strong) NSArray *msgs;

- (instancetype)init;


-(void)showWithDataArray:(NSArray*)array block:(SelectPickViewBlock)block;


@end
