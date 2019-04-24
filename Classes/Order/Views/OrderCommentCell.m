//
//  OrderCommentCell.m
//  Qqw
//
//  Created by zagger on 16/8/29.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "OrderCommentCell.h"
#import "StarView.h"

#import "OrderModel.h"

#define maxCount 200

@interface OrderCommentCell ()<UITextViewDelegate>

@property (nonatomic, strong) OrderCmtBuildModel *cmtModel;

@property (nonatomic, strong) UIView *divierView;

@property (nonatomic, strong) UILabel *fixLabel;

@property (nonatomic, strong) StarView *cmtStarView;

@property (nonatomic, strong) UIView *divierLineView;



@end

@implementation OrderCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak typeof(self) wself = self;
        self.cmtStarView.starDidChangeBlock = ^(NSInteger star) {
            __strong typeof(wself) sself = wself;
            sself.cmtModel.star = star;
        };
        
        [self addSubview:self.divierView];
        [self addSubview:self.fixLabel];
        [self addSubview:self.cmtStarView];
        [self addSubview:self.divierLineView];
        [self addSubview:self.textView];
        
        self.hideAfterSale = YES;
        [self configSubLayout];
    }
    return self;
}

- (void)refreshWithCommentInfo:(OrderCmtBuildModel *)cmtModel {
    [self refreshWithOrderGoods:cmtModel.goodsModel];
    
    self.cmtModel = cmtModel;
    self.cmtStarView.star = cmtModel.star;
    self.textView.text = [cmtModel.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _editTextViewBlock(textView);
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
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
    
    NSString *content = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.cmtModel.content = content;
}

- (void)showMaxCountRemind {
    [Utils postMessage:[NSString stringWithFormat:@"最多只能输入%d个字", maxCount] onView:self.superview];
}

#pragma mark - configSubLayout
- (void)configSubLayout {
    CGFloat hMargin = 10;
    
    [self.divierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImgView.mas_bottom).offset(10);
        make.left.right.equalTo(@0);
        make.height.equalTo(@5);
    }];
    
    [self.fixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.top.equalTo(self.divierView.mas_bottom);
        make.height.equalTo(@35);
    }];
    
    [self.cmtStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fixLabel.mas_right);
        make.centerY.equalTo(self.fixLabel);
        make.height.equalTo(@18);
        make.width.equalTo(@90);
    }];
    
    [self.divierLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.fixLabel.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.divierLineView.mas_bottom).offset(10);
        make.left.equalTo(@(hMargin - 3.0));
        make.right.equalTo(@(-1*(hMargin - 3.0)));
        make.height.equalTo(@100);
    }];
}

#pragma mark - Properties
- (UIView *)divierView {
    if (!_divierView) {
        _divierView = [[UIView alloc] init];
        _divierView.backgroundColor = DefaultBackgroundColor;
    }
    return _divierView;
}

- (UILabel *)fixLabel {
    if (!_fixLabel) {
        _fixLabel = GeneralLabel(Font(13), TextColor2);
        _fixLabel.text = @"评价：";
    }
    return _fixLabel;
}

- (StarView *)cmtStarView {
    if (!_cmtStarView) {
        _cmtStarView = [StarView generalStarView];
    }
    
    return _cmtStarView;
}

- (UIView *)divierLineView {
    if (!_divierLineView) {
        _divierLineView = [[UIView alloc] init];
        _divierLineView.backgroundColor = DividerDarkGrayColor;
    }
    return _divierLineView;
}

- (SZTextView *)textView {
    if (!_textView) {
        _textView = [[SZTextView alloc] init];
        _textView.font = Font(13);
        _textView.textColor = TextColor2;
        _textView.delegate = self;
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.placeholder = @"请在此写下您的评语";
    }
    return _textView;
}

@end




@implementation OrderCmtBuildModel


@end
