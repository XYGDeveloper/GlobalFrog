//
//  BrandFactoryCollectionViewAgent.h
//  Qqw
//
//  Created by zagger on 16/9/9.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandFactoryCollectionViewAgent : NSObject

- (id)initWithParentViewController:(UIViewController *)parentVC;

- (void)refreshWithDataArray:(NSArray *)dataArray;

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@end





@interface BrandFactoryColletionViewLayout : UICollectionViewFlowLayout

@end