//
//  OrderDetailFoldCell.m
//  Qqw
//
//  Created by zagger on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderDetailFoldCell.h"
#import "UIImage+Common.h"

@interface OrderDetailFoldCell ()

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UIImageView *arrowImgView;

@property (nonatomic, strong) UIButton *foldButton;

@end

@implementation OrderDetailFoldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.foldButton];
        [self.contentView addSubview:self.arrowImgView];
        [self.contentView addSubview:self.stateLabel];
        
        [self.foldButton addTarget:self action:@selector(foldButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self configLayout];
    }
    
    return self;
}

- (void)configLayout {
    [self.foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(@1);
        make.height.equalTo(@30);
    }];
    
    
    CGFloat arrowWidth = self.arrowImgView.image.size.width;
    CGFloat padding = 4.0;
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.foldButton);
        make.centerX.equalTo(self).offset(-0.5*(arrowWidth + padding));
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.foldButton);
        make.left.equalTo(self.stateLabel.mas_right).offset(padding);
    }];
}

- (void)foldButtonClicked:(id)sender {
    if (self.foldBlock) {
        self.foldBlock();
    }
}

- (void)refreshWithFold:(BOOL)isFold foldCount:(NSInteger)foldCount {
    if (isFold) {
        self.arrowImgView.image = [UIImage imageNamed:@"orderDetail_foldDown"];
        self.stateLabel.text = [NSString stringWithFormat:@"还有%ld件",(long)foldCount];
    } else {
        self.arrowImgView.image = [UIImage imageNamed:@"orderDetail_foldUp"];
        self.stateLabel.text = @"收起";
    }
}



#pragma mark - Properties
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = GeneralLabel(Font(13), HexColor(0x323232));
    }
    return _stateLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orderDetail_foldDown"]];
    }
    return _arrowImgView;
}

- (UIButton *)foldButton {
    if (!_foldButton) {
        _foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_foldButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _foldButton.layer.borderColor = TextColor2.CGColor;
        _foldButton.layer.borderWidth = 0.5;
    }
    return _foldButton;
}

@end
