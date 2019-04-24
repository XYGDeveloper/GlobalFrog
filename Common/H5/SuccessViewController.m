//
//  SuccessViewController.m
//  Qqw
//
//  Created by zagger on 16/9/6.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "SuccessViewController.h"
#import "NSString+Attribute.h"

typedef void(^SuccessPageOperationBlock)(void);

@interface SuccessViewController ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *successLabel;

@property (nonatomic, strong) UIView *dividerLineView;

@property (nonatomic, strong) UILabel *explainLabel;

@property (nonatomic, strong) UILabel *contactLabel;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, copy) SuccessPageOperationBlock leftOperationBlock;

@property (nonatomic, copy) SuccessPageOperationBlock rightOperationBlock;

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self configLayout];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}

- (void)popButtonClicked:(id)sender {
    if (self.popBackViewController && [self.navigationController.viewControllers containsObject:self.popBackViewController]) {
        [self.navigationController popToViewController:self.popBackViewController animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Public Methods
+ (instancetype)paySuccessViewControllerWithJumpBack:(UIViewController *)toViewController {
    SuccessViewController *vc = [[SuccessViewController alloc] init];
    vc.title = @"支付成功";
    vc.popBackViewController = toViewController;
    
    [vc configWithSuccessText:@"恭喜您支付成功"
                   expainText:@"我们将尽快为您发货，请保持联系方式的畅通！"
                  contactText:[NSString stringWithFormat:@"如有疑问，请拨打：%@", kServicePhoneNumber]
                leftOperation:@"继续购物"
                 leftCallback:^{
                     [Utils jumpToHomepage];
                 }
               rightOperation:@"返回我的订单"
                rightCallback:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kJumpToOrderListPageNotify object:OrderReqStatusWaitSend];
                }];
    
    return vc;
}

+ (instancetype)orderCommentSuccessViewController {
    SuccessViewController *vc = [[SuccessViewController alloc] init];
    vc.title = @"评论成功";
    
    weakify(vc)
    [vc configWithSuccessText:@"评价成功"
                   expainText:@"感谢您对本次购物的评价"
                  contactText:nil
                leftOperation:nil
                 leftCallback:nil
               rightOperation:@"返回我的订单"
                rightCallback:^{
                    strongify(vc)
                    
                    if (vc.popBackViewController && [vc.navigationController.viewControllers containsObject:vc.popBackViewController]) {
                        [vc.navigationController popToViewController:vc.popBackViewController animated:YES];
                    } else {
                        [vc.navigationController popViewControllerAnimated:YES];
                    }
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kJumpToOrderListPageNotify object:OrderReqStatusAll];
                }];
    
    vc.explainLabel.textAlignment = NSTextAlignmentCenter;
    
    return vc;
}

+ (instancetype)orderCancelSuccessViewControllerWithReason:(NSString *)cancelReason order:(NSString *)orderId {
    SuccessViewController *vc = [[SuccessViewController alloc] init];
    vc.title = @"取消成功";
    
    weakify(vc)
    [vc configWithSuccessText:@"取消成功"
                   expainText:[NSString stringWithFormat:@"您取消的理由：%@。", cancelReason]
                  contactText:[NSString stringWithFormat:@"如有疑问，请拨打：%@", kServicePhoneNumber]
                leftOperation:@"查看详情"
                 leftCallback:^{
                     [[NSNotificationCenter defaultCenter] postNotificationName:kJumpToOrderDetailPageNotify object:orderId];
                 }
               rightOperation:@"返回我的订单"
                rightCallback:^{
                    strongify(vc)
                    [vc.navigationController popViewControllerAnimated:YES];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kJumpToOrderListPageNotify object:OrderReqStatusAll];
                }];
    
    
    return vc;
}

+ (instancetype)afterSaleApplySuccessViewControllerWithOrder:(NSString *)orderId {
    SuccessViewController *vc = [[SuccessViewController alloc] init];
    vc.title = @"提交申请";
    
    weakify(vc)
    [vc configWithSuccessText:@"申请成功"
                   expainText:@"全球蛙工作人员将在24小时内联系您，请耐心等待"
                  contactText:nil
                leftOperation:@"查看详情"
                 leftCallback:^{
                     [[NSNotificationCenter defaultCenter] postNotificationName:kJumpToOrderDetailPageNotify object:orderId];
                 }
               rightOperation:@"返回我的订单"
                rightCallback:^{
                    strongify(vc)
                    if (vc.popBackViewController && [vc.navigationController.viewControllers containsObject:vc.popBackViewController]) {
                        [vc.navigationController popToViewController:vc.popBackViewController animated:YES];
                    } else {
                        [vc.navigationController popViewControllerAnimated:YES];
                    }
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kJumpToOrderListPageNotify object:OrderReqStatusAll];
                }];
    
    vc.explainLabel.textAlignment = NSTextAlignmentCenter;
    
    return vc;
}


#pragma mark - Pravite Methods
- (void)configWithSuccessText:(NSString *)successText
                   expainText:(NSString *)explainText
                  contactText:(NSString *)contactText
                leftOperation:(NSString *)leftOperationTitle
                 leftCallback:(SuccessPageOperationBlock)leftOperationBlock
               rightOperation:(NSString *)rightOperationTitle
                rightCallback:(SuccessPageOperationBlock)rightOperationBlock {
    
    self.successLabel.text = successText;
    self.explainLabel.text = explainText;
    self.contactLabel.attributedText = [contactText attributedStringByMarkPattern:@"[\\d{1,},-]" withFont:Font(12) color:AppStyleColor];
    [self.leftButton setTitle:leftOperationTitle forState:UIControlStateNormal];
    [self.rightButton setTitle:rightOperationTitle forState:UIControlStateNormal];
    self.leftOperationBlock = leftOperationBlock;
    self.rightOperationBlock = rightOperationBlock;
    
}

#pragma mark - Events
- (void)leftButtonClicked:(id)sender {
    if (self.leftOperationBlock) {
        self.leftOperationBlock();
    }
}

- (void)rightButtonClicked:(id)sender {
    
    if (self.rightOperationBlock) {
        self.rightOperationBlock();
    }
}


#pragma mark - configLayout
- (void)configLayout {
    CGFloat hMargin = 34.0;
    
    CGFloat imageWidth = self.imgView.image.size.width;
    CGFloat padding = 18.0;
    
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.successLabel];
    [self.view addSubview:self.dividerLineView];
    [self.view addSubview:self.explainLabel];
    
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@82);
        make.centerX.equalTo(self.view).offset(0.5*(imageWidth + padding));
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.successLabel);
        make.right.equalTo(self.successLabel.mas_left).offset(-1*padding);
    }];
    
    [self.dividerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.right.equalTo(@(-1*hMargin));
        make.top.equalTo(self.successLabel.mas_bottom).offset(20);
        make.height.equalTo(@0.5);
    }];
    
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.right.equalTo(@(-1*hMargin));
        make.top.equalTo(self.dividerLineView.mas_bottom).offset(10);
    }];
    
    UIView *flagView = self.explainLabel;
    if (self.contactLabel.text.length > 0) {
        [self.view addSubview:self.contactLabel];
        
        [self.contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(hMargin));
            make.right.equalTo(@(-1*hMargin));
            make.top.equalTo(self.explainLabel.mas_bottom).offset(10);
        }];
        flagView = self.contactLabel;
    }
    
    NSString *leftTitle = [self.leftButton titleForState:UIControlStateNormal];
    if (leftTitle.length > 0) {
        [self.view addSubview:self.leftButton];
        [self.view addSubview:self.rightButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(flagView.mas_bottom).offset(34);
            make.width.equalTo(@110);
            make.height.equalTo(@44);
            make.right.equalTo(self.view.mas_centerX).offset(-13);
            
        }];
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(flagView.mas_bottom).offset(34);
            make.width.equalTo(@110);
            make.height.equalTo(@44);
            make.left.equalTo(self.view.mas_centerX).offset(13);
        }];
        
    } else {
        [self.view addSubview:self.rightButton];
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(flagView.mas_bottom).offset(34);
            make.width.equalTo(@110);
            make.height.equalTo(@44);
            make.centerX.equalTo(self.view);
        }];
    }
}

#pragma mark - Properties
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_paySuccess"]];
    }
    return _imgView;
}

- (UILabel *)successLabel {
    if (!_successLabel) {
        _successLabel = GeneralLabel(BFont(18), AppStyleColor);
    }
    return _successLabel;
}

- (UIView *)dividerLineView {
    if (!_dividerLineView) {
        _dividerLineView = [[UIView alloc] init];
        _dividerLineView.backgroundColor = DividerGrayColor;
    }
    return _dividerLineView;
}

- (UILabel *)explainLabel {
    if (!_explainLabel) {
        _explainLabel = GeneralLabel(Font(14), TextColor2);
    }
    return _explainLabel;
}

- (UILabel *)contactLabel {
    if (!_contactLabel) {
        _contactLabel = GeneralLabel(Font(12), TextColor2);
    }
    return _contactLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIHelper generalRaundCornerButtonWithTitle:@""];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIHelper appstyleBorderButtonWithTitle:@""];
        _rightButton.titleLabel.font = Font(14);
    }
    return _rightButton;
}

@end
