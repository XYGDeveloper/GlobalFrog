//
//  QqwSexRadioCell.h
//  Qqw
//
//  Created by elink on 16/7/28.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger
{
    male,
    female
} sex;

typedef void(^SexSelectedBlock)(sex sex);
@interface QqwSexRadioCell : UITableViewCell
-(void)setSexSelected:(sex)sex withSelectResult:(SexSelectedBlock)result;
@end
