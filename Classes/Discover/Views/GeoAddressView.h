//
//  GeoAddressView.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/18.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
typedef void(^SelectMapPoiBlock)(AMapPOI *mapPoi);

@interface GeoAddressView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong,readonly) UITableView * tabelView;

@property(nonatomic,strong,readonly) NSMutableArray * dataArray;

@property(nonatomic,copy) SelectMapPoiBlock selectMapPoiBlock;


-(void)showWithData:(NSMutableArray*)data;



-(void)showWithView:(UIView*)view data:(NSMutableArray*)data;

-(void)dismiss;

@end
