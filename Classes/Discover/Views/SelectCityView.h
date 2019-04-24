//
//  SelectCityView.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/17.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchAddressView.h"
@interface SelectCityView : UIView<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray*leftKeyArrat;
}

@property(nonatomic,strong,readonly) UITableView * tabelView;

@property(nonatomic,strong,readonly)NSMutableDictionary * cityDictionary;

@property(nonatomic,copy) SelectSearchBlock selectBlcok;

@end
