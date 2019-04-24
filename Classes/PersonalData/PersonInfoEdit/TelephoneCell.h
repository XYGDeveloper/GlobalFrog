//
//  TelephoneCell.h
//  Qqw
//
//  Created by XYG on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelephoneCell : UITableViewCell
@property(nonatomic,strong)UILabel* titleLab;
@property(nonatomic,strong)UILabel* contentLab;
-(void)setTitle:(NSString*)title withContent:(NSString*)content;

@end
