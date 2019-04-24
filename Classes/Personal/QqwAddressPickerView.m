//
//  QqwAddressPickerView.m
//  Qqw
//
//  Created by elink on 16/7/26.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "QqwAddressPickerView.h"
#import "QqwProvinceModel.h"
#import "Utils.h"
#import "User.h"
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
@interface QqwAddressPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIView* coverView;
@property(nonatomic,strong)UIView* bottomView;
@property(nonatomic,strong)UIPickerView* addressPicker;
@property(nonatomic,strong)UIView* view;
@property(nonatomic,strong)NSArray* dataArr;
@property(nonatomic,assign)NSInteger provinceIndex;
@property(nonatomic,assign)NSInteger cityIndex;
@property(nonatomic,assign)NSUInteger areaIndex;
@property(nonatomic,copy)addressSelectBlock selectBlock;
@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation QqwAddressPickerView

+(QqwAddressPickerView*)showAddressPickerViewOn:(id)view SelectedResult:(addressSelectBlock)select
{
    QqwAddressPickerView* picker = [[QqwAddressPickerView alloc] init];
    picker.selectBlock = select;
    picker.view = view;
    return picker;
    
}

-(instancetype)init
{
    if (self=[super init]) {
        
        [self initData];
       
        
    }
    
    return self;
}

-(UIView *)coverView
{
    if (!_coverView) {
        
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,SCREEN_HEIGHT)];
        
        _coverView.backgroundColor = [UIColor colorWithRed:125.0f/255.0f green:125.0f/255.0f blue:125.0f/255.0f alpha:0.3f];
        
        [_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCoverView)]];
        
        SEL sel = NSSelectorFromString(@"addSubview:");
        
        if ([self.view respondsToSelector:sel]) {
            
           [self.view performSelector:sel withObject:_coverView];
           
            
        }
        
    }
    return _coverView;
}

-(void)initData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"xml"];
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    
    NSString *xmlString = [NSString stringWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:NULL];
    NSArray *arr = [Utils addressInfoFromXml:xmlString];
    
    NSArray *modelArray = [QqwProvinceModel mj_objectArrayWithKeyValuesArray:arr];

    
    self.dataArr = modelArray;
    self.provinceIndex = 0;
    self.cityIndex = 0;
    self.areaIndex = 0;
    
}

-(UIView*)bottomView
{
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT+300.0f,kScreenWidth,300.0f)];
        _bottomView.backgroundColor =[UIColor colorWithRed:231.0f/255.0f green:231.0f/255.0f blue:231.0f/255.0f alpha:1.0f];
        
        UIButton* cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,80.0f,40.0f)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:AppStyleColor forState:UIControlStateNormal];

        [cancleBtn addTarget:self action:@selector(hiddenCoverView) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancleBtn];
        
        UIButton* confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-80.0f,0.0f,80.0f,40.0f)];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:AppStyleColor forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:confirmBtn];
        
        [self.coverView addSubview:_bottomView];
    
    }
    
    return _bottomView;
}

-(UIPickerView *)addressPicker
{
    if (!_addressPicker) {
        
        _addressPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40,kScreenWidth,260.0f)];
        _addressPicker.backgroundColor = [UIColor whiteColor];
        
        _addressPicker.dataSource = self;
        
        _addressPicker.delegate = self;
        
        [self.bottomView addSubview:_addressPicker];
        
    }
    
    return _addressPicker;
}

#pragma mark - PickerDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        
        return self.dataArr.count;
        
    }else if (component==1)
    {
        QqwProvinceModel* model = [self.dataArr safeObjectAtIndex:self.provinceIndex];
        
        return model.cities.count;
        
    }else
    {
        QqwProvinceModel* Province = [self.dataArr safeObjectAtIndex:self.provinceIndex];
        
        QqwCityModel* city = [Province.cities safeObjectAtIndex:self.cityIndex];
        
        return city.areas.count;
    }
}

#pragma mark - PickerViewDelegate



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth/3.0f, 30)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor =HexColorA(0x323232,0.8);

    if (component == 0) {
        
        QqwProvinceModel* province = self.dataArr[row];
        
        _titleLabel.text = province.name;
        
    }
    else if (component == 1) {
        
        
        QqwProvinceModel* province = self.dataArr[self.provinceIndex];
        
        QqwCityModel* city = province.cities[row];
        
        _titleLabel.text =  city.name;
        
    }
    else {
        
        
        QqwProvinceModel* province = self.dataArr[self.provinceIndex];
        
        QqwCityModel* city = province.cities[self.cityIndex];
        
        QqwAreaModel *area = city.areas[row];
       
        _titleLabel.text = area.name;
        
        
    }
    return _titleLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        
        self.provinceIndex = row;
        self.cityIndex = 0;
        self.areaIndex = 0;
        
        [self.addressPicker reloadComponent:1];
        [self.addressPicker reloadComponent:2];
        [self.addressPicker selectRow:0 inComponent:1 animated:YES];
        [self.addressPicker selectRow:0 inComponent:2 animated:YES];
        
    }
    else if (component==1)
    {
        self.cityIndex = row;
        self.areaIndex = 0;
        
        [self.addressPicker reloadComponent:2];
        [self.addressPicker selectRow:0 inComponent:2 animated:YES];
        
    }else
    {
        self.areaIndex = row;
    }
}

-(void)show
{
    [self.addressPicker selectRow:self.provinceIndex inComponent:0 animated:YES];
    [self.addressPicker selectRow:self.cityIndex inComponent:1 animated:YES];
    [self.addressPicker selectRow:self.areaIndex inComponent:2 animated:YES];
    
    if (![[self.view subviews] containsObject:self.coverView]) {
        
        SEL sel = NSSelectorFromString(@"addSubview:");
        
        if ([self.view respondsToSelector:sel]) {
            
            [self.view performSelector:sel withObject:_coverView];
        }
    }
    
    [UIView animateWithDuration:0.1f animations:^{
       
        self.bottomView.frame = CGRectMake(0,SCREEN_HEIGHT-300.0f,kScreenWidth,300.0f);
        
    }];
}

-(void)hiddenCoverView
{
    [UIView animateWithDuration:0.3f animations:^{
        
        self.bottomView.frame = CGRectMake(0,SCREEN_HEIGHT+300.0f,kScreenWidth,300.0f);
        
    }completion:^(BOOL finished) {
        
        [self.coverView removeFromSuperview];
    }];
}

-(void)confirmAction
{
    if (self.selectBlock) {
        
        
        NSString* province = [self.dataArr[self.provinceIndex] valueForKeyPath:@"name"];
        NSString *proID = [self.dataArr[self.provinceIndex] valueForKeyPath:@"postcode"];
        NSString* city = [[self.dataArr[self.provinceIndex] valueForKeyPath:@"cities"][self.cityIndex] valueForKeyPath:@"name"];
        NSString *cityID  = [[self.dataArr[self.provinceIndex] valueForKeyPath:@"cities"][self.cityIndex] valueForKeyPath:@"postcode"];
        NSString* area = [[[self.dataArr[self.provinceIndex] valueForKeyPath:@"cities"][self.cityIndex] valueForKeyPath:@"areas"][self.areaIndex]valueForKeyPath:@"name"];
        NSString* areaID = [[[self.dataArr[self.provinceIndex] valueForKeyPath:@"cities"][self.cityIndex] valueForKeyPath:@"areas"][self.areaIndex]valueForKeyPath:@"postcode"];
        
        NSString* result = [province stringByAppendingFormat:@" %@ %@ %@ %@ %@",city,area,proID,cityID,areaID];
        
        self.selectBlock(result);
        
        [self hiddenCoverView];
        
    }
}

- (void)dealloc
{
    self.coverView = nil;
    self.bottomView = nil;
    self.addressPicker = nil;
    self.view = nil;
    self.dataArr = nil;
    self.selectBlock = nil;
    
    NSLog(@"%@销毁了",NSStringFromClass([self class]));
    
}
@end
