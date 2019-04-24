//
//  MyPickView.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/6.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "MyPickView.h"

@implementation MyPickView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
     
        UIView * backVew = [[UIView alloc]init];
        backVew.backgroundColor = [UIColor blackColor];
        backVew.alpha = 0.3;
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
//        [backVew addGestureRecognizer:tap];
        [self addSubview:backVew];
        [backVew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(@0);
        }];
        
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = NO;
        [self addSubview:_pickerView];
        
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@(0));
            make.height.equalTo(@180);
        }];
        
        UILabel * msgLabel = [UILabel new];
        msgLabel.text = @"订单数量较大，以下为目前可选择配送的时间段";
        msgLabel.font = [UIFont systemFontOfSize:13];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.adjustsFontSizeToFitWidth = YES;
        msgLabel.backgroundColor = [UIColor rgb:MSG_color];
        [self addSubview:msgLabel];
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(_pickerView.mas_top).offset(0);
            make.height.equalTo(@25);
        }];
        
        
        UIView * b = [[UIView alloc]init];
        b.backgroundColor = [UIColor whiteColor];
        [self addSubview:b];
        [b mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(msgLabel.mas_top).offset(0);
            make.height.equalTo(@45);

        }];
        
        UIButton * canBut = [UIButton buttonWithType:(UIButtonTypeSystem)];
        UIButton * okBut = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [canBut addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [okBut addTarget:self action:@selector(clickOkBut) forControlEvents:UIControlEventTouchUpInside];

        [b addSubview:canBut];
        [b addSubview:okBut];
        [canBut setTintColor:[UIColor rgb:BK_Color]];
        [okBut setTintColor:[UIColor rgb:BK_Color]];
        [canBut setTitle:@"取消" forState:NO];
        [okBut setTitle:@"确定" forState:NO];

        [canBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@13);
            make.centerY.equalTo(b.mas_centerY);
            make.height.equalTo(@30);
            make.width.equalTo(@50);
        }];
        
        [okBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(b.mas_centerY);
            make.right.equalTo(@-13);
            make.height.equalTo(canBut.mas_height);
            make.width.equalTo(canBut.mas_width);
        }];
        
        UIView * linView = [UIView new];
        linView.backgroundColor = [UIColor lightGrayColor];
        [b addSubview:linView];
        [linView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.left.height.equalTo(@0.5);
        }];
        
    }
    return self;
}

#pragma mark ================== pickveiw delegat =================
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:14]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [_names count];
    }else if (component == 1) {
        return [_times count];
    }else
        return [_msgs count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0){
        return [_names objectAtIndex: row];
    }else if (component == 1){
        TimeInfo * t = [_times objectAtIndex: row];
        return t.show;
    }
    return [_msgs objectAtIndex: row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *str2, *time;
    if (component == 0) {
        ShowTimeInfo * show = [_dataSource objectForKey:@(row)];
        _times = show.list;
        selectStr1 = show.name;
        if (_times.count>0) {
            TimeInfo * t = [_times objectAtIndex: 0];
            str2 = t.show;
            time = t.time;
        }
        [pickerView reloadComponent: 1];
        [pickerView selectRow: 0 inComponent: 1 animated: YES];
    }else if (component == 1){
        if (_times.count>0) {
            TimeInfo * t = [_times objectAtIndex: row];
            str2 = t.show;
            time = t.time;
        }
    }else{
        return;
    }
    [self setPutMsgWithStr:str2 time:time];
}

#pragma mark ================== wode =================
-(void)clickOkBut{
    clickBlock(_selectString);
    [self dismiss];
}
-(void)show{
    [[AppDelegate APP].window addSubview:self];
}


-(void)showWithDataArray:(NSArray *)array block:(SelectPickViewBlock)block{
    clickBlock = block;
    if (!_dataSource) {
        _dataSource = [NSMutableDictionary new];
    }
    [_dataSource removeAllObjects];
    
    for (int i = 0; i<array.count; i++) {
        ShowTimeInfo * show = array[i];
        [_dataSource setObject:show forKey:@(i)];
    }
    [self loadData];
    [_pickerView reloadAllComponents];
    [self show];
}

-(void)loadData{
    selectStr1 = @"";
    NSArray *components = [_dataSource allKeys];
    NSMutableArray *nameTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[components count]; i++) {
        ShowTimeInfo * show = [_dataSource objectForKey:@(i)];
        [nameTmp addObject: show.name];
        
    }
    _names =  [[NSArray alloc] initWithArray: nameTmp];
    if (_names.count>0) {
        selectStr1 = _names[0];
        _msgs = @[@"免运费"];
    }
    
    ShowTimeInfo * show = [_dataSource objectForKey:@(0)];
    _times = show.list;

    TimeInfo * t = nil ;
    if (_times.count>0) {
        t = [_times objectAtIndex: 0];
    }
   
    NSString *str2, *time;
    str2 = t.show;
    time = t.time;
    [self setPutMsgWithStr:str2 time:time];
    
}

-(void)setPutMsgWithStr:(NSString*)str2 time:(NSString*)time{
    if (!selectStr1) {
        selectStr1 = @"";
    }

    if (!str2) {
        str2 = @"";
    }
    if (!time) {
        time = @"";
    }
    _selectString = [NSString stringWithFormat:@"%@ %@&%@",selectStr1,str2,time];
}

-(void)dismiss{
    [self removeFromSuperview];
}

@end
