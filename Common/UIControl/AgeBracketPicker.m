//
//  AgeBracketPicker.m
//  Qqw
//
//  Created by zagger on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "AgeBracketPicker.h"
#import "ZGPickerView.h"

@interface AgeBracketPicker ()<ZGPickerViewDataSource, ZGPickerViewDelegate>

@property (nonatomic, strong) ZGPickerView *pickerView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) void(^selectBlock)(NSString *ageBracket);

@end

@implementation AgeBracketPicker

+ (void)showOnView:(UIView *)parentView withSelectBlock:(void(^)(NSString *ageBracket))selectBlock {
    [AgeBracketPicker shreadPicker].selectBlock = selectBlock;
    [[AgeBracketPicker shreadPicker].pickerView showOnView:parentView];
}

+ (instancetype)shreadPicker {
    static AgeBracketPicker *__picker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __picker = [[AgeBracketPicker alloc] init];
    });
    return __picker;
}

- (id)init {
    if (self = [super init]) {
        self.dataArray = @[@"22以下",@"23-35",@"36-45",@"46以上"];
    }
    return self;
}


#pragma mark - ZGPickerViewDataSource & ZGPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(ZGPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(ZGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (NSString *)pickerView:(ZGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.dataArray safeObjectAtIndex:row];
}

- (void)pickerView:(ZGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

- (void)pickerViewDidClickedConfirmButton:(ZGPickerView *)pickerView {
    
    if (self.selectBlock) {
        self.selectBlock([self.dataArray safeObjectAtIndex:[pickerView selectedRowInComponent:0]]);
    }
    
    [self.pickerView hide];
}


#pragma mark - Properties
- (ZGPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [ZGPickerView generalPickerView];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}


@end
