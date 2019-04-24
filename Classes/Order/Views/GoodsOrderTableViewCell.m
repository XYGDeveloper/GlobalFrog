//
//  GoodsOrderTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/7.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "GoodsOrderTableViewCell.h"
#import "GoodsTableViewCell.h"
#import "CostTableViewCell.h"

#define DEFINE_HEIGHT 20
static NSString * goodsCell = @"goodsCell";
static NSString * costCell = @"costCell";
static NSString * defStr = @"选填（限50字内）";
@implementation GoodsOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _orderTabelView.bounces = NO;
    _orderTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _orderTabelView.alwaysBounceVertical = NO;
    _linLayoutheight.constant = 0.5;
    
    _desTextView.textColor = [UIColor lightGrayColor];
    _desTextView.delegate = self;

    [_orderTabelView registerNib:[UINib nibWithNibName:@"GoodsTableViewCell" bundle:nil] forCellReuseIdentifier:goodsCell];
    [_orderTabelView registerNib:[UINib nibWithNibName:@"CostTableViewCell" bundle:nil] forCellReuseIdentifier:costCell];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchSxView:)];
    [_sxView addGestureRecognizer:tap];
    self.selectionStyle = NO;
}

-(void)touchSxView:(UITapGestureRecognizer*)tap{
    if (!pickView) {
        pickView = [MyPickView new];
    }
    if (_car.timelist.count == 0) {
        [Utils showErrorMsg:[AppDelegate APP].window type:0 msg:@"不在营业时间内！"];
    }else{
        [pickView showWithDataArray:_car.timelist block:^(NSString *str) {
            if (str.length>3) {
                NSArray * s = [str componentsSeparatedByString:@"&"];
                _timeLabel.text = s[0];
                _car.time = s[1];
            }
        }];
    }

}

-(void)setCar:(CartGroupItem *)car{
    _car = car;
    _typeNameLabel.text = car.name;
    
    _desTextView.text = car.remark.length>0?car.remark:defStr;
    _timeLabel.text = _car.time.length>0?_car.time:@"请选择";
    
    for (CartGoodsModel * goods in car.list) {
        if (goods.is_limit) {
            _msgLabel.text = @"  下列有因配送范围、库存原因而导致失效的商品";
            _msgLabelLayout.constant = DEFINE_HEIGHT;
            break;
        }else{
            _msgLabelLayout.constant = 0;
            _msgLabel.text = nil;
        }
    }
    if (car.rtype == 4) {
        _sxViewLayout.constant = 35;
    }else{
        _sxViewLayout.constant = 0;
    }
    
//    if (car.rtype == 0) {
    _postageLabel.text = [NSString stringWithFormat:@"¥ %@",car.packingFee];
    _postageLabel.textColor = PriceColor;
//    }else{
//        _postageLabel.text = car.shipping;
//    }
 
    [self layoutIfNeeded];
    
    NSString * str = [NSString stringWithFormat:@"共%lu件商品    小记：¥%0.2f",(unsigned long)car.list.count,[self allPrice]];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange  ran = [str rangeOfString:@"："];
    [attr addAttribute:NSForegroundColorAttributeName value:PriceColor range:NSMakeRange(ran.location+ran.length, str.length-ran.location-ran.length)];
    _goodsInfoLabel.attributedText = attr;

    [_orderTabelView reloadData];
}

-(float)allPrice{
    float f = 0;
    for (CartGoodsModel * g in _car.list) {
        if (!g.is_limit) {
            f = f+g.sale_price.floatValue*g.goods_number.intValue;
        }
    }
    return f;
}

#pragma mark ================== Table view data source =================
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _car.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCell];
    cell.goods = _car.list[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ================== textView delegate =================
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self setTextViewInfoEnd:NO textView:textView];
    _editTextViewBlock(textView);
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [self setTextViewInfoEnd:YES textView:textView];
}

-(void)textViewDidChangeSelection:(UITextView *)textView{
    if (![textView.text isEqualToString:defStr]) {
        _car.remark = textView.text;
    }else{
        _car.remark = @"";
    }
}

#pragma mark ================== wode =================
-(void)setTextViewInfoEnd:(BOOL)end textView:(UITextView*)textView{
    if (end) {
        if(textView.text.length == 0||textView.text == nil){
            textView.textColor = [UIColor lightGrayColor];
            textView.text = defStr;
        }
    }else{
        if ([textView.text isEqualToString:defStr]) {
            textView.text = nil;
        }
        textView.textColor = [UIColor blackColor];
    }
}

+(CGFloat)cellHeightWithCarInfo:(CartGroupItem *)car{
    CGFloat f = 0;
    for (CartGoodsModel * goods in car.list) {
        if (goods.is_limit) {
            f = DEFINE_HEIGHT;
            break;
        }else{
            f = 0;
        }
    }
    CGFloat f2 = 0;
    if (car.rtype == 4) {
        f2 = 35;
    }
    return 44+80*car.list.count+112+f+f2;
}

#pragma mark ================== super =================
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
//    [_desTextView removeObserver:self forKeyPath:@"text" context:nil];
}

@end
