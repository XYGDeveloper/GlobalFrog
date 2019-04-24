//
//  SearchAddressTableViewCell.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/17.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AMapSearchKit/AMapSearchKit.h>
@interface SearchAddressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cruLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property(nonatomic,strong) AMapPOI * mapPoi;


@end
