//
//  DistributeViewController.h
//  Qqw
//
//  Created by xyg on 2017/1/8.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"
#import "UpdownLoadMutibleImageApi.h"
#import "DistriButePictureApi.h"
#import "MyTextView.h"
#import "OJLAnimationButton.h"
@interface DistributeViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,OJLAnimationButtonDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ApiRequestDelegate,UIActionSheetDelegate>
@property (nonatomic , copy)void (^changeFlage)(NSInteger flags);
//点击列表，讲评论的tid传递过来，以tid作为参数去发布评论和晒图。
@property (nonatomic, strong)NSString *tid;

@end
