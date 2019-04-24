//
//  OrderListCell.m
//  Qqw
//
//  Created by zagger on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderListCell.h"
#import <UIImageView+WebCache.h>
#import "OrderModel.h"
typedef void(^TimerStopBlock)();
typedef void (^getTime)(NSString *time);

@interface OrderListCell ()
{
    // 定时器
    NSTimer *timer;
}



@property (nonatomic,copy)TimerStopBlock timerStopBlock;
@property (nonatomic,copy)getTime time;
@property (nonatomic,strong)NSString *timeValue;
@property (nonatomic,assign)long timerValue;
@property (nonatomic, strong) NSMutableArray *operationButtons;

@property (nonatomic, strong) UILabel *numberLabel;//订单编号

@property (nonatomic, strong) UIImageView *goodsImgView;

@property (nonatomic, strong) UILabel *goodsNameLabel;

@property (nonatomic, strong) UILabel *goodsCountLabel;

@property (nonatomic, strong) UILabel *packageLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIView *dividerLineView1;
@property (nonatomic, strong) UIView *dividerLineView2;

@property (nonatomic, strong) UIImageView *sxImgView;

@end

@implementation OrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:self.statusLabel];
        [self.contentView addSubview:self.dividerLineView1];
        [self.contentView addSubview:self.goodsImgView];
        [self.contentView addSubview:self.goodsNameLabel];
        [self.contentView addSubview:self.goodsCountLabel];
        [self.contentView addSubview:self.packageLabel];
        [self.contentView addSubview:self.dividerLineView2];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.sxImgView];
        [self configLayout];
    }
    return self;
}

- (void)setModel:(OrderModel *)order{
    _model = order;
    self.statusLabel.text = order.status;
    weakify(self);
    self.timerStopBlock = ^{
        timer = nil;
        strongify(self);
        if (self.freshList) {
            
            self.freshList();
            
        }
        
        
    };
    
    OrderGoodsModel *goods = [_model.goods_list safeObjectAtIndex:0];
    //    switch (goods.rtype) {
    //        case 0:
    //            self.numberLabel.text = @"平台直供";
    //            break;
    //        case 1:
    //            self.numberLabel.text = @"工厂直供";
    //            break;
    //        case 2:
    //            self.numberLabel.text = @"保税直邮";
    //            break;
    //        case 4:
    //            self.numberLabel.text = @"蛙鲜生";
    //            break;
    //        default:
    //            break;
    //    }
    self.numberLabel.text = order.order_type_name;
    [self.numberLabel sizeToFit];
    if (goods.rtype != 4) {
        [self.sxImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
            make.width.equalTo(@0);
        }];
    }else{
        [self.sxImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@34);
            make.width.equalTo(@18);
        }];
    }
//    [self layoutIfNeeded];
    
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:[UIHelper smallPlaceholder]];
    self.goodsNameLabel.text = goods.goods_name;
    self.goodsCountLabel.text = [NSString stringWithFormat:@"共%lu个商品",(unsigned long)order.goods_list.count];
    //    self.packageLabel.text = @"包裹1";//TODO:包裹显示逻辑
    
    NSString *priceStr = [Utils priceDisplayStringFromPrice:order.order_amount];
    NSString *fixStr = @"实付：";
    NSString *str = [NSString stringWithFormat:@"%@%@",fixStr,priceStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:TextColor2 range:[str rangeOfString:fixStr]];
    self.priceLabel.attributedText = attStr;
    
    [self refreshOperationButtons:order.status_code];

}


#pragma mark - Private Methods
- (void)refreshOperationButtons:(NSArray *)m {
    if (!self.operationButtons) {
        self.operationButtons = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    for (UIButton *btn in self.operationButtons) {
        [btn removeFromSuperview];
    }
    [self.operationButtons removeAllObjects];
    
//    OrderGoodsModel *goods = [_model.goods_list safeObjectAtIndex:0];
//    NSMutableArray * m = [[NSMutableArray alloc]initWithArray:opArray];
//    if (goods.rtype == 4) {
//        for (OrderOperation *operation in m) {
//            if ( [operation.code isEqualToString:kOrderOperationTrack]) {
//                [m removeObject:operation];
//            }
//        }
//    }
    
    UIButton *tempButton = nil;
    for (int i = 0; i < m.count; i ++) {
        OrderOperation *operation = [m safeObjectAtIndex:i];
        
        UIButton *opButton = nil;
        if (i == 0) {
            opButton = [UIHelper appstyleBorderButtonWithTitle:operation.title];
        } else {
            opButton = [UIHelper grayBorderButtonWithTitle:operation.title];
        }
        
        opButton.operation = operation;
        [opButton addTarget:self action:@selector(operationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:opButton];
        [self.operationButtons safeAddObject:opButton];
        
        [opButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@64);
            make.height.equalTo(@24);
            make.centerY.equalTo(self.priceLabel);
            if (tempButton) {
                make.right.equalTo(tempButton.mas_left).offset(-12);
            } else {
                make.right.equalTo(self).offset(-9);
            }
        }];
        
        tempButton = opButton;
    }
}

- (void)operationButtonClicked:(UIButton *)sender {
    if (self.operationBlock) {
        self.operationBlock(sender.operation);
    }
}


#pragma mark - Layout
- (void)configLayout {
    CGFloat leftMargin = 9.0;
    CGFloat rightMargin = 9.0;

    [self.sxImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftMargin));
        make.top.equalTo(@0);
        make.height.equalTo(@34);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sxImgView.mas_right).offset(5);;
        make.top.equalTo(@0);
        make.height.equalTo(@34);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-1*rightMargin);
        make.top.equalTo(@0);
        make.height.equalTo(self.numberLabel);
    }];
    
    [self.dividerLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftMargin));
        make.right.equalTo(@(-1*rightMargin));
        make.top.equalTo(self.numberLabel.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftMargin));
        make.top.equalTo(self.dividerLineView1.mas_bottom).offset(5);
        make.width.height.equalTo(@70);
    }];
    
    [self.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImgView.mas_right).offset(16);
        make.right.equalTo(self.packageLabel.mas_left).offset(-10);
        make.bottom.equalTo(self.goodsImgView.mas_centerY).offset(-3);
    }];
    
    [self.goodsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsNameLabel);
        make.top.equalTo(self.goodsImgView.mas_centerY).offset(3);
    }];
    
    [self.packageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-1*rightMargin);
        make.centerY.equalTo(self.goodsImgView);
    }];
    
    [self.dividerLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftMargin));
        make.right.equalTo(@(-1*rightMargin));
        make.top.equalTo(self.goodsImgView.mas_bottom).offset(5);
        make.height.equalTo(@0.5);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftMargin));
        make.bottom.equalTo(@0);
        make.height.equalTo(@39);
    }];
}

#pragma mark - Properties
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.font = Font(14);
        _numberLabel.textColor = TextColor2;
    }
    return _numberLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = Font(11);
        _statusLabel.textColor = TextColor2;
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

- (UIImageView *)goodsImgView {
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.clipsToBounds = YES;
        _goodsImgView.contentMode = UIViewContentModeScaleAspectFill;
        
        _goodsImgView.layer.cornerRadius = 2.0;
        _goodsImgView.layer.masksToBounds = YES;
        _goodsImgView.layer.borderColor = DividerGrayColor.CGColor;
        _goodsImgView.layer.borderWidth = 0.5;
    }
    return _goodsImgView;
}

- (UILabel *)goodsNameLabel {
    if (!_goodsNameLabel) {
        _goodsNameLabel = [[UILabel alloc] init];
        _goodsNameLabel.backgroundColor = [UIColor clearColor];
        _goodsNameLabel.font = Font(13);
        _goodsNameLabel.numberOfLines = 2;
        _goodsNameLabel.textColor = TextColor2;
        [_goodsNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _goodsNameLabel;
}

- (UILabel *)goodsCountLabel {
    if (!_goodsCountLabel) {
        _goodsCountLabel = [[UILabel alloc] init];
        _goodsCountLabel.backgroundColor = [UIColor clearColor];
        _goodsCountLabel.font = Font(12);
        _goodsCountLabel.textColor = TextColor2;
    }
    return _goodsCountLabel;
}

- (UILabel *)packageLabel {
    if (!_packageLabel) {
        _packageLabel = [[UILabel alloc] init];
        _packageLabel.backgroundColor = [UIColor clearColor];
        _packageLabel.textAlignment = NSTextAlignmentRight;
        _packageLabel.font = Font(12);
        _packageLabel.textColor = TextColor2;
    }
    return _packageLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.font = Font(12);
        _priceLabel.textColor = PriceColor;
    }
    return _priceLabel;
}

- (UIView *)dividerLineView1 {
    if (!_dividerLineView1) {
        _dividerLineView1 = [[UIView alloc] init];
        _dividerLineView1.backgroundColor = DividerGrayColor;
    }
    return _dividerLineView1;
}

- (UIView *)dividerLineView2 {
    if (!_dividerLineView2) {
        _dividerLineView2 = [[UIView alloc] init];
        _dividerLineView2.backgroundColor = DividerGrayColor;
    }
    return _dividerLineView2;
}

-(UIImageView *)sxImgView{
    if (!_sxImgView) {
        _sxImgView = [UIImageView new];
        _sxImgView.image = [UIImage imageNamed:@"samll——xia"];
        _sxImgView.contentMode = UIViewContentModeScaleAspectFit;
        _sxImgView.clipsToBounds = YES;
    }
    return _sxImgView;
}

#pragma mark - 计时器方法
- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp{
    NSInteger ms = timestamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    NSLog(@"------------------%ld:%ld",(long)minute,(long)second);
    
    NSString *min;
    NSString *se;
    
    if (minute<10) {
        min = [NSString stringWithFormat:@"0%ld",(long)minute];
    }else{
        min = [NSString stringWithFormat:@"%ld",(long)minute];
    }
    if (second<10) {
        se = [NSString stringWithFormat:@"0%ld",(long)second];
    }else{
        se = [NSString stringWithFormat:@"%ld",(long)second];
    }
    
    
    self.time([NSString stringWithFormat:@"还剩%@:%@",min,se]);
    
    self.timerValue = second + minute * 60;
   
    
}



// 拿到外界传来的时间戳
- (void)setTimestamp:(NSInteger)timestamp{
    _timestamp = timestamp;
    if (_timestamp != 0) {
        timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        
    }
}


// 初始化timer

-(void)timer:(NSTimer*)timerr{
    _timestamp--;
    [self getDetailTimeWithTimestamp:_timestamp];
    if (_timestamp == 0) {
        [timer invalidate];
        timer = nil;
        // 执行block回调
        self.timerStopBlock();
    }
}




@end



@implementation UIButton (OrderOperation)

static const char OrderOperationKey = '\0';

- (void)setOperation:(OrderOperation *)operation {
    if (operation != self.operation) {
        [self willChangeValueForKey:@"operation"];
        objc_setAssociatedObject(self, &OrderOperationKey, operation, OBJC_ASSOCIATION_RETAIN);
        [self didChangeValueForKey:@"operation"];
    }
}

- (OrderOperation *)operation {
    return objc_getAssociatedObject(self, &OrderOperationKey);
}






@end
