//
//  GoodsOrderTableViewCell.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/7.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartGoodsModel.h"
#import "MyPickView.h"

typedef void(^EditTextViewBlock)(UITextView * textView);
@interface GoodsOrderTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    MyPickView * pickView;
}

@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgLabelLayout;

@property (weak, nonatomic) IBOutlet UITableView *orderTabelView;

@property (weak, nonatomic) IBOutlet UITextView *desTextView;

@property (weak, nonatomic) IBOutlet UILabel *goodsInfoLabel;

@property (weak, nonatomic) IBOutlet UIView *sxView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sxViewLayout;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *postageLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linLayoutheight;

@property(nonatomic,copy) EditTextViewBlock  editTextViewBlock;

@property(nonatomic,strong) CartGroupItem * car;


+(CGFloat)cellHeightWithCarInfo:(CartGroupItem *) car;

@end
