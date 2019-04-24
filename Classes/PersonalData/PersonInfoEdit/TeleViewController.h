//
//  TeleViewController.h
//  Qqw
//
//  Created by XYG on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^textFiledResultBlock)(NSString* text);
@interface TeleViewController : UIViewController
-(id)initWithTitle:(NSString*)title textContent:(NSString*)content TextFiledResult:(textFiledResultBlock)result;

@end
