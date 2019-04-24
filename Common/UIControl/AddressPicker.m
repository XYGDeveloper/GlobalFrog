//
//  AddressPicker.m
//  Qqw
//
//  Created by zagger on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "AddressPicker.h"
#import "ZGPickerView.h"
#import "QqwProvinceModel.h"

@interface AddressPicker ()<ZGPickerViewDataSource, ZGPickerViewDelegate>

@property (nonatomic, strong) ZGPickerView *pickerView;

@property (nonatomic, strong) NSArray *areaInfoArray;

@property (nonatomic, copy) void(^selectBlock)(AddressModel *address);

@end

@implementation AddressPicker

+ (void)showOnView:(UIView *)parentView withSelectBlock:(void(^)(AddressModel *address))selectBlock {
    [AddressPicker shreadPicker].selectBlock = selectBlock;
    [[AddressPicker shreadPicker].pickerView showOnView:parentView];
}

+ (instancetype)shreadPicker {
    static AddressPicker *__picker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __picker = [[AddressPicker alloc] init];
    });
    return __picker;
}

- (id)init {
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"xml"];
        NSURL *fileUrl = [NSURL fileURLWithPath:path];
        
        NSString *xmlString = [NSString stringWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:NULL];
        NSArray *arr = [Utils addressInfoFromXml:xmlString];
        
        self.areaInfoArray = [QqwProvinceModel mj_objectArrayWithKeyValuesArray:arr];
    }
    return self;
}


#pragma mark - ZGPickerViewDataSource & ZGPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(ZGPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(ZGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.areaInfoArray.count;
    } else if (component == 1) {
        QqwProvinceModel *province = [self.areaInfoArray safeObjectAtIndex:[pickerView selectedRowInComponent:0]];
        return province.cities.count;
    } else if (component == 2) {
        QqwProvinceModel *province = [self.areaInfoArray safeObjectAtIndex:[pickerView selectedRowInComponent:0]];
        QqwCityModel *city = [province.cities safeObjectAtIndex:[pickerView selectedRowInComponent:1]];
        return city.areas.count;
    }
    return 0;
}

- (NSString *)pickerView:(ZGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        QqwProvinceModel *province = [self.areaInfoArray safeObjectAtIndex:row];
        return province.name;
    } else {
        QqwProvinceModel *province = [self.areaInfoArray safeObjectAtIndex:[pickerView selectedRowInComponent:0]];
        QqwCityModel *city = [province.cities safeObjectAtIndex:row];
        if (component == 1) {
            return city.name;
        } else if (component == 2) {
            QqwCityModel *city = [province.cities safeObjectAtIndex:[pickerView selectedRowInComponent:1]];
            QqwAreaModel *area = [city.areas safeObjectAtIndex:row];
            return area.name;
        }
    }
    return @"";
}

- (void)pickerView:(ZGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
    } else if (component == 1) {
        [self.pickerView reloadComponent:2];
    } else if (component == 2) {
        
    }
}

- (void)pickerViewDidClickedConfirmButton:(ZGPickerView *)pickerView {
    QqwProvinceModel *province = [self.areaInfoArray safeObjectAtIndex:[pickerView selectedRowInComponent:0]];
    QqwCityModel *city = [province.cities safeObjectAtIndex:[pickerView selectedRowInComponent:1]];
    QqwAreaModel *area = [city.areas safeObjectAtIndex:[pickerView selectedRowInComponent:2]];
    
    AddressModel *address = [[AddressModel alloc] init];
    address.province = province.name;
    address.province_code = province.postcode;
    address.city = city.name;
    address.city_code = city.postcode;
    address.district = area.name;
    address.district_code = area.postcode;
    
    if (self.selectBlock) {
        self.selectBlock(address);
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
