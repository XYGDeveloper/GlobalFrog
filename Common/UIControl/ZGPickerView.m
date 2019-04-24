//
//  ZGPickerView.m
//  Zhuzhu
//
//  Created by zagger on 16/1/4.
//  Copyright © 2016年 www.globex.cn. All rights reserved.
//

#import "ZGPickerView.h"
CGFloat const kTopBarHeight = 44.0;
CGFloat const kPickerViewHeight = 200;

@interface ZGPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIView *topBar;

@property (nonatomic, strong) UIView *topBarTopBorderView;
@property (nonatomic, strong) UIView *topBarBottomBorderView;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;


@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIView *maskView;

@end

@implementation ZGPickerView

- (void)dealloc {
    _pickerView.delegate = nil;
    _pickerView.dataSource = nil;
}

+ (instancetype)generalPickerView {
    return [[ZGPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopBarHeight + kPickerViewHeight)];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.topBar addSubview:self.topBarTopBorderView];
        [self.topBar addSubview:self.topBarBottomBorderView];
        [self.topBar addSubview:self.cancelButton];
        [self.topBar addSubview:self.confirmButton];
        [self.topBar addSubview:self.titleLabel];
        [self addSubview:self.topBar];
        [self addSubview:self.pickerView];
        
        [self bringSubviewToFront:self.topBar];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topBar.frame = CGRectMake(0, 0, self.width, kTopBarHeight);
    self.topBarTopBorderView.frame = CGRectMake(0, 0, self.topBar.width, 0.5);
    self.topBarBottomBorderView.frame = CGRectMake(0, self.topBar.height - 0.5, self.topBar.width, 0.5);
    
    self.cancelButton.frame = CGRectMake(0, 0, self.cancelButton.width + 24.0, self.topBar.height);
    self.confirmButton.frame = CGRectMake(self.topBar.width - (self.confirmButton.width + 24.0), 0, self.confirmButton.width + 24.0, self.topBar.height);
    
    self.titleLabel.frame = CGRectMake(self.cancelButton.origin.x + self.cancelButton.width + 4, 0, self.width - self.cancelButton.width - self.confirmButton.width - 8.0, kTopBarHeight);
    
    self.pickerView.centerY = self.topBar.bottom + 0.5*kPickerViewHeight;
}

#pragma mark - Public Methods
- (void)showOnView:(UIView *)parentView {
    if (!parentView) {
        parentView = [UIApplication sharedApplication].keyWindow;
    }
    
    self.maskView.frame = parentView.bounds;
    [parentView addSubview:self.maskView];
    
    self.top = parentView.height;
    [parentView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.bottom = parentView.height;
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.top = self.superview.height;
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
        if (self.maskView.superview) {
            [self.maskView removeFromSuperview];
        }
    }];
}

- (void)reloadAllComponents {
    [self.pickerView reloadAllComponents];
}
- (void)reloadComponent:(NSInteger)component {
    [self.pickerView reloadComponent:component];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    [self.pickerView selectRow:row inComponent:component animated:animated];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    return [self.pickerView selectedRowInComponent:component];
}

- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle {
    [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
}

- (void)setconfirmButtonTitle:(NSString *)confirmButtonTitle {
    [self.confirmButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
}

#pragma mark - Events
- (void)cancelButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewDidClickedCancelButton:)]) {
        [self.delegate pickerViewDidClickedCancelButton:self];
    }
    [self hide];
}

- (void)confirmButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewDidClickedConfirmButton:)]) {
        [self.delegate pickerViewDidClickedConfirmButton:self];
    }
    [self hide];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        return [self.dataSource numberOfComponentsInPickerView:self];
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        return [self.dataSource pickerView:self numberOfRowsInComponent:component];
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:widthForComponent:)]) {
        return [self.delegate pickerView:self widthForComponent:component];
    }
    
    NSInteger numberOfComponets = 1;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        numberOfComponets = [self.dataSource numberOfComponentsInPickerView:self];
    }
    
    return self.width / numberOfComponets;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:rowHeightForComponent:)]) {
        [self.delegate pickerView:self rowHeightForComponent:component];
    }
    return 35;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
        NSString *title = [self.delegate pickerView:self titleForRow:row forComponent:component];
        if (!title) {
            return view;
        }
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:title];
        
        NSRange range = NSMakeRange(0, title.length);
        [attributedTitle addAttribute:NSFontAttributeName value:Font(17) range:range];
        [attributedTitle addAttribute:NSForegroundColorAttributeName value:HexColor(0x323232) range:range];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.attributedText = attributedTitle;
        
        return label;
    }
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:row inComponent:component];
    }
}


#pragma mark - Helper
- (UIButton *)generalButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = Font(17);
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:AppStyleColor forState:UIControlStateNormal];
    
    [button sizeToFit];
    
    return button;
}

#pragma mark - Properties
- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc] initWithFrame:CGRectZero];
        _topBar.backgroundColor = DefaultBackgroundColor;
    }
    return _topBar;
}

- (UIView *)topBarTopBorderView {
    if (!_topBarTopBorderView) {
        _topBarTopBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        _topBarTopBorderView.backgroundColor = [UIColor whiteColor];
    }
    return _topBarTopBorderView;
}

- (UIView *)topBarBottomBorderView {
    if (!_topBarBottomBorderView) {
        _topBarBottomBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        _topBarBottomBorderView.backgroundColor = [UIColor whiteColor];
    }
    return _topBarBottomBorderView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [self generalButtonWithTitle:@"取消"];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [self generalButtonWithTitle:@"完成"];
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (void)setHideCancelButton:(BOOL)hideCancelButton {
    _hideCancelButton = hideCancelButton;
    self.cancelButton.hidden = hideCancelButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = Font(14);
        _titleLabel.textColor = AppStyleColor;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.3);
    }
    return _maskView;
}

@end
