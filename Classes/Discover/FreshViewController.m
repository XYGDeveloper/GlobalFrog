//
//  FreshViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/6.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "FreshViewController.h"
#import "LocationAddressView.h"
#import "SelectAddressController.h"
#import "SearchViewController.h"

@interface FreshViewController (){
    LocationAddressView * locationView;
    NSString * currentCity;
    NSString * loctionCityName;
    
    CLLocation * currentLocation;
}


@end

@implementation FreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.openURLInNewController = YES;
    UIButton * b = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [b setImage:[UIImage imageNamed:@"nav_search"] forState:NO];
    b.tintColor = [UIColor rgb:BK_Color];
    [b addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    b.frame = CGRectMake(0, 0, 25, 25);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:b];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectAddress:) name:KNotification_Select_Address object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showSeletViewCtr) name:KNotification_Fresh_SelectAddress object:nil];
    
    locationView = [[LocationAddressView alloc]initWithFrame:CGRectMake(0, 0, self.view.width-50, 20) block:^{
        [self showSeletViewCtr];
    }];
    locationView.userInteractionEnabled = NO;

    [self location];
    
    self.myWebView.scrollView.mj_header =  [QQWRefreshHeader headerWithRefreshingBlock:^{
        [self loadRequest];
    }];
}

-(void)showSeletViewCtr{
    dispatch_async(dispatch_get_main_queue(), ^{
        SelectAddressController * s = [SelectAddressController new];
        s.loctionCityName = loctionCityName;
        [self.navigationController pushViewController:s animated:YES];
    });
}

-(NSString *)requestURLString{
    return  H5_FRESH_URL;
}


-(void)loadRequest{
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5_FRESH_URL]]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark ================== noty =================
-(void)selectAddress:(NSNotification*)noty{
    AMapPOI * a = noty.object;
    locationView.addressLabel.text =  [NSString stringWithFormat:@"%@▼",a.name];
    [AppDelegate APP].locationCoordinate = CLLocationCoordinate2DMake(a.location.latitude, a.location.longitude);
    [self loadRequest];
}

#pragma mark ================== wode =================
- (void)location {
    [[LocationManager sharedManager]startLocationUpdateLocation:^(CLLocation * tmpLocation) {
        locationView.userInteractionEnabled = YES;
        currentLocation = tmpLocation;
        [AppDelegate APP].locationCoordinate = currentLocation.coordinate;

    } Success:^(CLPlacemark *placeMark) {
        currentCity = placeMark.locality;
        if (!currentCity) {
            currentCity = @"无法定位当前城市";
        }
        loctionCityName = placeMark.locality;
        locationView.addressLabel.text =  [NSString stringWithFormat:@"%@▼",placeMark.name];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:locationView];
        [self loadRequest];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)clickSearch{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.searchType = SearchType_wsx;
    vc.currentLocation = currentLocation;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    [self.myWebView.scrollView.mj_header endRefreshing];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.myWebView.scrollView.mj_header endRefreshing];
    if (error.code == -1009) {
        [[EmptyManager sharedManager] showNetErrorOnView:self.view response:nil operationBlock:^{
            [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestURLString]]];
        }];
        return;
    }
    if ([error.domain isEqualToString:@"NSURLErrorDomain"] || [error.domain isEqualToString:@"WebKitErrorDomain"] ) {
        if (error.code == NSURLErrorCancelled || error.code == 102 || error.code == 204 || error.code == 101) {
            return;
        }
    }
    
}

#pragma mark ================== super =================
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
