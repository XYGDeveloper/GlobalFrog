//
//  GoodsCollectionViewAgent.h
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopModel.h"
@interface GoodsCollectionViewAgent : NSObject

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

- (id)initWithParentViewController:(UIViewController *)parentViewController;

- (void)reloadWithItems:(NSArray *)itemArray;

@end




@interface GoodsCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
