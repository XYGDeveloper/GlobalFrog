//
//  VipEditCell.m
//  Qqw
//
//  Created by zagger on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "VipEditCell.h"

@interface VipEditCell ()<UITextFieldDelegate>

@property (nonatomic, strong, readwrite) UIImage *normalImage;
@property (nonatomic, strong, readwrite) UIImage *editedImage;
@property (nonatomic, strong, readwrite) UIImageView *iconView;

@property (nonatomic, strong, readwrite) UITextField *textField;

@end

@implementation VipEditCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.maxEditCount = INT16_MAX;
        
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.textField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@17);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(@10);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.right.equalTo(@-10);
    }];
}

#pragma mark - Events
- (void)textDidChange:(NSNotification *)note {
    UITextField *textField = [note object];
    if (textField == self.textField) {
        [self contentDidChange];
    }
}

- (void)contentDidChange {
    self.iconView.image = self.text.length > 0 ? self.editedImage : self.normalImage;
    if (self.contentChangedBlock) {
        self.contentChangedBlock();
    }
}

#pragma mark - Public Methods
- (void)setIcon:(UIImage *)image editedIcon:(UIImage *)editedImage placeholder:(NSString *)placeholder {
    self.normalImage = image;
    self.editedImage = editedImage;
    self.iconView.image = self.text.length > 0 ? self.editedImage : self.normalImage;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [str addAttribute:NSForegroundColorAttributeName value:HexColor(0x909090) range:NSMakeRange(0, placeholder.length)];
    self.textField.attributedPlaceholder = str;
}

- (NSString *)text {
    return [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)setText:(NSString *)text {
    self.textField.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self contentDidChange];
}

- (void)setEditAble:(BOOL)editAble {
    self.textField.enabled = editAble;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= self.maxEditCount && string.length > range.length) {
        return NO;
    }
    return YES;
}



#pragma mark - Properties
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.clipsToBounds = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.delegate = self;
        _textField.font = Font(13);
        _textField.textColor = HexColor(0x323232);
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
    return _textField;
}

@end
