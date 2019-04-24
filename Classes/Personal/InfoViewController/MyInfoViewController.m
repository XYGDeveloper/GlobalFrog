//
//  MyInfoViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "MyInfoViewController.h"
#import "OrderCountModel.h"

@interface MyInfoViewController ()<SegmentContainerDelegate>

@property (nonatomic, strong) SegmentContainer *container;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic,strong)OrderCountModel *orderCountInfo;

@end

@implementation MyInfoViewController

- (NSArray *)titleArray{
    if (!_titleArray) {
        NSString *message;
        if (_orderCountInfo.msgs.intValue>0) {
            message = [NSString stringWithFormat:@"私信(%@)",_orderCountInfo.msgs];
        }else{
            message = @"私信";
        }

        NSString *comments;
        if (_orderCountInfo.comments.intValue>0) {
             comments = [NSString stringWithFormat:@"评论(%@)",_orderCountInfo.comments];
        }else{
             comments = @"评论";
        }

        NSString *systemMessage;
        if (_orderCountInfo.systmes.intValue>0) {
            systemMessage = [NSString stringWithFormat:@"系统消息(%@)",_orderCountInfo.systmes];
        }else{
            systemMessage = @"系统消息";
        }

        _titleArray = [NSArray arrayWithObjects:message,comments,systemMessage, nil];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    [OrderCountModel requestInfoWithSuperView:nil finshBlock:^(OrderCountModel * obj, NSError *error) {
        if (error == nil) {
            _orderCountInfo = obj;
            [self.view addSubview:self.container];
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
}

#pragma mark - Properties
- (SegmentContainer *)container {
    if (!_container) {
        _container = [[SegmentContainer alloc] initWithFrame:self.view.bounds];
        _container.parentVC = self;
        _container.delegate = self;
        _container.titleFont = Font(13);
        _container.titleNormalColor = TextColor2;
        _container.titleSelectedColor = TextColor1;
        _container.containerBackgroundColor = DefaultBackgroundColor;
        _container.indicatorColor = AppStyleColor;
    }
    return _container;
}

#pragma mark - SegmentContainerDelegate
- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    return self.titleArray.count;
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    return [self.titleArray safeObjectAtIndex:index];
}

- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index {
    if (index == 0) {
        PrivateMessageViewController *private = [PrivateMessageViewController new];
        return private;
    }else if (index == 1){
        ConmmentViewController *comment = [ConmmentViewController new];
        return comment;
    }else{
        SystemInfoViewController *system = [SystemInfoViewController new];
        return system;
    }
}

- (void)segmentContainer:(SegmentContainer *)segmentContainer didSelectedItemAtIndex:(NSUInteger)index {
    
}


@end
