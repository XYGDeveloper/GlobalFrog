//
//  BrandFatoryListCell.h
//  Qqw
//
//  Created by zagger on 16/9/9.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@class BrandFactory;
@interface BrandFatoryListCell : BaseCollectionViewCell

- (void)refreshWithBrandFactoryModel:(BrandFactory *)model;

@end
