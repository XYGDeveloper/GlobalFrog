//
//  ZGPickerView.h
//  Zhuzhu
//
//  Created by zagger on 16/1/4.
//  Copyright © 2016年 www.globex.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZGPickerViewDataSource;
@protocol ZGPickerViewDelegate;

@interface ZGPickerView : UIView

@property (nonatomic, weak) id<ZGPickerViewDataSource> dataSource;
@property (nonatomic, weak) id<ZGPickerViewDelegate> delegate;
/**pickerview 居中显示标题 默认没有内容*/
@property (nonatomic, strong) UILabel *titleLabel;

/** 是否显示取消按钮，默认为NO，若要隐藏取消按钮，将该值设为YES */
@property (nonatomic, assign) BOOL hideCancelButton;

/** 设置取消按钮标题，默认是“取消” */
- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle;

/** 设置确定按钮标题，默认是“完成” */
- (void)setconfirmButtonTitle:(NSString *)confirmButtonTitle;

/** 返回一个通用的pickerView对象 */
+ (instancetype)generalPickerView;

/** 如果parentView为nil的话，将会默认显示在当前的keywindow上 */
- (void)showOnView:(UIView *)parentView;
- (void)hide;

- (void)reloadAllComponents ;
- (void)reloadComponent:(NSInteger)component;

/** 选中对应component的对应行 */
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

/** 返回对应component选中的行 */
- (NSInteger)selectedRowInComponent:(NSInteger)component;

@end


@protocol ZGPickerViewDataSource<NSObject>
@required

- (NSInteger)numberOfComponentsInPickerView:(ZGPickerView *)pickerView;
- (NSInteger)pickerView:(ZGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
@end


@protocol ZGPickerViewDelegate<NSObject>
@optional
/** component的宽度，默认为总宽度除以component数 */
- (CGFloat)pickerView:(ZGPickerView *)pickerView widthForComponent:(NSInteger)component;
/** 每一行的高度，默认为35*/
- (CGFloat)pickerView:(ZGPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

/** 对应位置显示的标题 */
- (NSString *)pickerView:(ZGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

/** 选中某一行时的回调方法 */
- (void)pickerView:(ZGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

/** 点击了取消按钮 */
- (void)pickerViewDidClickedCancelButton:(ZGPickerView *)pickerView;

/** 点击了确定按钮 */
- (void)pickerViewDidClickedConfirmButton:(ZGPickerView *)pickerView;

@end
