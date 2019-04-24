//
//  ComponViewController.m
//  Qqw
//
//  Created by 全球蛙 on 16/9/2.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "ComponViewController.h"

#import "CouponTableViewController.h"
@interface ComponViewController ()<SegmentContainerDelegate>

@property (nonatomic, strong) SegmentContainer *container;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ComponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券";
    [self.view addSubview:self.container];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
}

- (NSArray *)titleArray
{
    
    if (!_titleArray) {
        
        _titleArray = [NSArray arrayWithObjects:@"未使用",@"已使用",@"已失效", nil];
    }
    
    return _titleArray;
    
    
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
    
    CouponTableViewController * c = [[CouponTableViewController alloc]initWithStyle:(UITableViewStylePlain)];
    c.conponType = index;
    return c;
}


- (void)segmentContainer:(SegmentContainer *)segmentContainer didSelectedItemAtIndex:(NSUInteger)index {
    
    
    
    
    
}


@end
