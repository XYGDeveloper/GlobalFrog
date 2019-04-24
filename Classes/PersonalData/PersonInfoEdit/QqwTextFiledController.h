//
//  QqwTextFiledController.h
//  Qqw
//
//  Created by elink on 16/7/28.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

typedef void(^textFiledResultBlock)(NSString* text);
@interface QqwTextFiledController : UIViewController
-(id)initWithTitle:(NSString*)title textContent:(NSString*)content TextFiledResult:(textFiledResultBlock)result;
@end
