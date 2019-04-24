//
//  UIViewController+Base.m
//  Qqw
//
//  Created by zagger on 16/8/25.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "UIViewController+Base.h"
#import <Aspects.h>
#import "CZCountDownView.h"
@implementation UIViewController (Base)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                                  withOptions:AspectPositionBefore
                                   usingBlock:^(id<AspectInfo> info) {
                                       UIViewController *viewController = [info instance];
                                       [viewController hookViewDidLoad];
                                   } error:NULL];
    });
}

- (void)hookViewDidLoad {
    if ([NSStringFromClass([self class]) hasPrefix:@"UI"] ||
        [NSStringFromClass([self class]) hasPrefix:@"_"]) {//这些系统类，不做hook
        return;
    }
    
//    if ([UIDevice SystemVersion] >= 7.0) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//    }
    
    self.view.backgroundColor = DefaultBackgroundColor;
    if (self.navigationController.viewControllers.count > 1) {
        [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"nav_back"] highligthtedImage:nil action:@selector(popButtonClicked:)];
    }
}

- (void)popButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark- 不显示导航栏

- (void)hiddenNavigationControllerBar
{
    self.navigationController.navigationBarHidden = YES;

}

#pragma mark - set navigationItem buttons
- (UIButton *)setLeftNavigationItemWithTitle:(NSString *)title action:(SEL)action {
    
    UIButton *button = [self navigationButtonWithTitle:title action:action];
    [self setLeftNavigationItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
    
    return button;
}

- (UIButton *)setLeftNavigationItemWithImage:(UIImage *)image highligthtedImage:(UIImage *)highlightedImage action:(SEL)action {
    
    UIButton *button = [self navigationButtonWithImage:image highligthtedImage:highlightedImage action:action];
    [self setLeftNavigationItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
    
    return button;
}

- (void)setLeftNavigationItems:(NSArray<UIView *> *)items {
    CGFloat xPos = 0;
    CGFloat xPadding = 0;
    
    UIView *itemView = [[UIView alloc] init];
    for (UIView *view in items) {
        if ([view isKindOfClass:[UIView class]]) {
            view.origin = CGPointMake(xPos, 0);
            xPos += (view.width + xPadding);
            [itemView addSubview:view];
        }
    }
    
    if (itemView.subviews.count > 0) {
        itemView.backgroundColor = [UIColor clearColor];
        itemView.frame = CGRectMake(0, 0, xPos - xPadding, self.navigationController.navigationBar.height);
        
        [self setLeftNavigationItem:[[UIBarButtonItem alloc] initWithCustomView:itemView]];
    }
}

- (UIButton *)setRightNavigationItemWithTitle:(NSString *)title action:(SEL)action {
    
    UIButton *button = [self navigationButtonWithTitle:title action:action];
    [self setRightNavigationItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
    return button;
    
}

- (UIView *)setTitleViewWithImage:(UIImage *)image {
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:image];
    logoImageView.size = CGSizeMake(100, 40);
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = logoImageView;
    return logoImageView;
}

- (UIButton *)setRightNavigationItemWithImage:(UIImage *)image highligthtedImage:(UIImage *)highlightedImage action:(SEL)action {
    
    UIButton *button = [self navigationButtonWithImage:image highligthtedImage:highlightedImage action:action];
    [self setRightNavigationItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
    
    return button;
}

- (void)setRightNavigationItems:(NSArray<UIView *> *)items {
    CGFloat xPos = 0;
    CGFloat xPadding = 0;
    UIView *itemView = [[UIView alloc] init];
    for (UIView *view in items) {
        if ([view isKindOfClass:[UIView class]]) {
            view.origin = CGPointMake(xPos, 0);
            xPos += (view.width + xPadding);
            [itemView addSubview:view];
        }
    }
    
    if (itemView.subviews.count > 0) {
        itemView.backgroundColor = [UIColor clearColor];
        itemView.frame = CGRectMake(0, 0, xPos - xPadding, self.navigationController.navigationBar.height);
        
        [self setRightNavigationItem:[[UIBarButtonItem alloc] initWithCustomView:itemView]];
    }
}

#pragma mark - helper
- (void)setLeftNavigationItem:(UIBarButtonItem *)leftItem {
    if (!leftItem || ![leftItem isKindOfClass:[UIBarButtonItem class]]) {
        return;
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithObject:leftItem];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -16;
    [itemArray insertObject:spaceButtonItem atIndex:0];
    
    self.navigationItem.leftBarButtonItems = itemArray;
}

- (void)setRightNavigationItem:(UIBarButtonItem *)rightItem {
    if (!rightItem || ![rightItem isKindOfClass:[UIBarButtonItem class]]) {
        return;
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithObject:rightItem];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -16;
    [itemArray insertObject:spaceButtonItem atIndex:0];
    
    self.navigationItem.rightBarButtonItems = itemArray;
}

- (UIButton *)navigationButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = Font(14);
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:AppStyleColor forState:UIControlStateNormal];
    [button sizeToFit];
    button.size = CGSizeMake(button.size.width + 10, 44.0);
    
    if (action) {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}

- (UIButton *)navigationButtonWithImage:(UIImage *)image highligthtedImage:(UIImage *)highlightedImage action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (highlightedImage) {
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    
    if (action) {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    button.size = CGSizeMake(44.0, 44.0);
    
    return button;
}

- (UIView *)setNavigationTitleViewWithView:(NSString *)title  timerWithTimer:(NSString *)timer{
    
    UIView *titleView = [self.navigationItem.titleView viewWithTag:10000];
    if (!titleView) {
        titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 230, 30)];
        titleView.tag = 10000;
        titleView.center = self.navigationItem.titleView.center;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.navigationItem.titleView = titleView;
            
        });
        
    }
    
    
    UILabel *titleLabel = [titleView viewWithTag:10001];
    if (!titleLabel) {
        titleLabel = [[UILabel alloc]init];
        titleLabel.tag = 10001;
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.textColor = HexColor(0x333333);
        titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [titleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(30);
        }];
    }
    titleLabel.text = title;
    
    
    
    UILabel *timerlabel  = [titleView viewWithTag:10002];
    if (!timerlabel) {
        timerlabel = [[UILabel alloc]init];
        timerlabel.tag = 10002;
        timerlabel.textColor = AppStyleColor;
        timerlabel.font = [UIFont systemFontOfSize:18.0f];
        timerlabel.textAlignment = NSTextAlignmentLeft;
        [titleView addSubview:timerlabel];
        [timerlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(80);
//            make.right.mas_equalTo(-40);
            make.height.mas_equalTo(30);
        }];
    }
    timerlabel.text = timer;
    
//    titleLabel.backgroundColor = [UIColor orangeColor];
//    timerlabel.backgroundColor = [UIColor greenColor];
//    titleView.backgroundColor = [UIColor redColor];
    return titleView;
}


- (UIView *)setNavigationtitleView:(UIView *)titleView
{

    self.navigationItem.titleView = titleView;
    return titleView;
    
}

#pragma mark -
static char kEventStatisticsKey = '\0';
- (NSString *)eventStatisticsId {
    return objc_getAssociatedObject(self, &kEventStatisticsKey);
}

- (void)setEventStatisticsId:(NSString *)eventStatisticsId {
    [self willChangeValueForKey:@"eventStatisticsId"];
    objc_setAssociatedObject(self, &kEventStatisticsKey, eventStatisticsId, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"eventStatisticsId"];
}






@end
