//
//  PromptView.h
//  Qqw
//
//  Created by 全球蛙 on 2017/2/28.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptView : UIView{
    UIView * bkView;
    UIView * bjView;
    UILabel * msglabel;
    
}

-(void)showWithMsg:(NSString*)msg;

@end
