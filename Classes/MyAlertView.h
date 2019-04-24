//
//  MyAlertView.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/29.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAlertView : UIView{
    
    UIView * backView;
    UILabel * titleLabel;
    UILabel * msgLabel;
    
    UIButton * okBut;
}

-(void)showWithShoppingCar;

@end
