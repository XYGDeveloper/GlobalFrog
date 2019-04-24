//
//  SortContainerViewController.m
//  Qqw
//
//  Created by zagger on 16/9/7.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "SortContainerViewController.h"
#import "SegmentContainer.h"
#import "SortViewController.h"
#import "BrandFactoryViewController.h"
#import "SearchViewController.h"
#import "QQWSearchBar.h"
#import "FilterSheet.h"

@interface SortContainerViewController ()<SegmentContainerDelegate,UISearchBarDelegate>

@property (nonatomic, strong) SegmentContainer *container;

@property (nonatomic, strong) FilterSheet *sheet;

@property (nonatomic, strong) BrandFactoryViewController *brandFactoryVC;

@end

@implementation SortContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QQWSearchBar *searchBar = [[QQWSearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"寻找品质生活";
    self.navigationItem.titleView = searchBar;
    
    [self.view addSubview:self.container];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}


#pragma mark - SegmentContainerDelegate
- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    return 2;
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    if (index == 0) {
        return @"商品分类";
    } else if (index == 1) {
        return @"品牌制造商";
    }
    return @"";
}

- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index {
    if (index == 0) {
        SortViewController *vc = [[SortViewController alloc] init];
        return vc;
    }
    else if (index == 1) {
        return self.brandFactoryVC;
    }
    return [[UIViewController alloc] init];
}

- (void)segmentContainer:(SegmentContainer *)segmentContainer didSelectedItemAtIndex:(NSUInteger)index {
//    if (index == 0) {
//        [MobClick event:kEventSortHomepage];
//        [self setRightNavigationItemWithTitle:@"" action:nil];
//        [self.sheet dismiss];
//    } else if (index == 1) {
//        [self setRightNavigationItemWithImage:[UIImage imageNamed:@"brand_sorting"] highligthtedImage:nil action:@selector(sortingButtonClicked:)];
//    }
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


- (FilterSheet *)sheet {
    if (!_sheet) {
        _sheet = [[FilterSheet alloc] initWithFrame:CGRectMake(kScreenWidth - 10.0 - 110, 50.0, 110.0, 78.0)];
        _sheet.dataArray = @[@"按销量排序",@"按喜欢排序"];
    }
    return _sheet;
}

- (BrandFactoryViewController *)brandFactoryVC {
    if (!_brandFactoryVC) {
        _brandFactoryVC = [[BrandFactoryViewController alloc] init];
    }
    return _brandFactoryVC;
}

@end
