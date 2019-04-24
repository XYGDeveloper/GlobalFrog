//
//  QqwPersonalViewController.h
//  Qqw
//
//  Created by 全球蛙 on 16/7/15.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "QqwPersonalHeadView.h"
@interface QqwPersonalViewController : UIViewController
@property(nonatomic,strong) QqwPersonalHeadView* headView;
@property(nonatomic,strong) UITableView* personTableView;
@property (nonatomic,strong)UIImageView *BgView;
@property (nonatomic,strong)UIButton *setButton;

//test
@property (nonatomic,strong)UIView *topView;

@end
