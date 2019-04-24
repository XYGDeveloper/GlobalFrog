//
//  SearchAddressView.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/17.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySegmentView.h"
#import "GeoAddressView.h"
typedef void(^SelectSearchBlock)(NSString * typeName);
@interface SearchAddressView : UIView<UITableViewDelegate,UITableViewDataSource,MySegmentViewDelegate>{
    UIView * backView;
    MySegmentView * segmentView;
}

@property(nonatomic,strong,readonly) UITableView * tabelView;

@property(nonatomic,copy) SelectSearchBlock selectBlcok;

@property(nonatomic,copy) SelectMapPoiBlock selectMapPoiBlock;

@property(nonatomic,strong) NSArray * dataArray;

-(void)show;

@end
