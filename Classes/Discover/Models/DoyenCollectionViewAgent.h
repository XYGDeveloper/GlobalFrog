//
//  DoyenCollectionViewAgent.h
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DoyenCollectionViewAgent : NSObject

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

/**
 *  是否要进行分组，默认为YES
 */
@property (nonatomic, assign) BOOL shouldGroup;

- (id)initWithParentViewController:(UIViewController *)parentViewController;

- (void)reloadWithItems:(NSArray *)itemArray;

@end




@interface TopicCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
