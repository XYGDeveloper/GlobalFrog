//
//  OrderMessageView.m
//  Qqw
//
//  Created by zagger on 16/8/19.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderMessageView.h"
#import "SZTextView.h"
#import "OrderConfirmViewConfig.h"

#define maxCount 45

@interface OrderMessageView ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *fixLabel;

@property (nonatomic, strong) SZTextView *textView;

@end

@implementation OrderMessageView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ORDER_CONFIRM_BACKGROUND_COLOR;
        [self addSubview:self.fixLabel];
        [self addSubview:self.textView];
        
        [self configLayout];
    }
    return self;
}

#pragma mark - Layout
- (void)configLayout {
    [self.fixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(ORDER_CONFIRM_LEFT_MARGIN));
        make.top.equalTo(@15);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fixLabel.mas_bottom).offset(10);
        make.left.equalTo(@(ORDER_CONFIRM_LEFT_MARGIN));
        make.right.equalTo(@(-1*ORDER_CONFIRM_RRIGHT_MARGIN));
        make.bottom.equalTo(@-10);
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        return NO;
    } else if (!textView.markedTextRange && textView.text.length >= maxCount && text.length > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showMaxCountRemind) object:nil];
        [self performSelector:@selector(showMaxCountRemind) withObject:nil afterDelay:0.2];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (!textView.markedTextRange && textView.text.length > maxCount) {
        textView.text = [textView.text substringToIndex:maxCount];
        textView.contentOffset = CGPointZero;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showMaxCountRemind) object:nil];
        [self performSelector:@selector(showMaxCountRemind) withObject:nil afterDelay:0.2];
    }
}

- (void)showMaxCountRemind {
    [Utils postMessage:[NSString stringWithFormat:@"最多只能输入%d个字", maxCount] onView:self.superview];
}

#pragma mark - getter
- (NSString *)leaveMessage {
    NSString *str = self.textView.text;
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - Properties
- (UILabel *)fixLabel {
    if (!_fixLabel) {
        _fixLabel = [[UILabel alloc] init];
        _fixLabel.backgroundColor = [UIColor clearColor];
        _fixLabel.font = Font(13);
        _fixLabel.textColor = TextColor2;
        _fixLabel.text = @"给商家留言";
    }
    
    return _fixLabel;
}

- (SZTextView *)textView {
    if (!_textView) {
        _textView = [[SZTextView alloc] init];
        _textView.font = Font(13);
        _textView.textColor = TextColor3;
        _textView.delegate = self;
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.placeholder = @"限45个字";
    }
    return _textView;
}

@end
