//
//  MapViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/7.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SearchAddressView.h"
#import "SelectCityView.h"
#import "GeoAddressView.h"

@interface MapViewController ()<AMapSearchDelegate,MAMapViewDelegate,UISearchBarDelegate>{
    MAMapView *_mapView;
    NSString * _myTypeName;
    UISearchBar *searchBar;
    SearchAddressView * searchView;
    GeoAddressView * geoAddressView;
}

@property (nonatomic, strong) NSArray<AMapPOI *> *searchDataArray;

@property(nonatomic,strong)AMapSearchAPI * search;
@property(nonatomic,strong) UIButton * cityButton;
@property(nonatomic,strong) SelectCityView * selectCityView;

@end

@implementation MapViewController
-(void)back{
    [searchBar endEditing:YES];
    geoAddressView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    UIButton *backButton = [self navigationButtonWithImage:[UIImage imageNamed:@"nav_back"] highligthtedImage:nil action:@selector(back)];
    _cityButton = [self navigationButtonWithTitle:[NSString stringWithFormat:@"%@▲",_loctionCityName] action:@selector(clickDw:)];
    [_cityButton setTitleColor:[UIColor blackColor] forState:NO];
    _cityButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self setLeftNavigationItems:@[backButton,_cityButton]];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    searchBar.placeholder = @"小区/写字楼/学校等";
    searchBar.backgroundImage = [UIImage imageNamed:@"bk_writh"];
    searchBar.delegate = self;
    UITextField *searchField=[searchBar valueForKey:@"_searchField"];
    searchField.backgroundColor =RGB(243, 243, 243);
    self.navigationItem.titleView = searchBar;
    [searchBar sizeToFit];
    
    _mapView = [AppDelegate APP].myMapView;
    _mapView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight/2+20);
    [self.view addSubview:_mapView];

    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    
    _myTypeName = @"";
  
    UIButton * but = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [but setImage:[UIImage imageNamed:@"dw38"] forState:NO];
    but.layer.cornerRadius = 2;
    but.backgroundColor = [UIColor whiteColor];
    but.tintColor = [UIColor grayColor];
    [but addTarget:self action:@selector(backLocation) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:but];
    [but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@23);
        make.bottom.equalTo(@-30);
        make.left.equalTo(@10);
    }];
    
    __weak MapViewController * sself = self;
    geoAddressView = [GeoAddressView new];
    geoAddressView.hidden = YES;
    geoAddressView.selectMapPoiBlock = ^(AMapPOI *mapPoi){
        if (sself.isNoPushRoot) {
            [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_Select_Address_ADD object:mapPoi];
            [sself.navigationController popViewControllerAnimated:YES];
        }else{
            [sself.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_Select_Address object:mapPoi];
        }
    };
   
    
    searchView = [[SearchAddressView alloc]init];
    searchView.selectBlcok = ^(NSString * typeName){
        _myTypeName = typeName;
        [sself searchAddress];
    };
    searchView.selectMapPoiBlock = ^(AMapPOI *mapPoi){
        if (sself.isNoPushRoot) {
            [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_Select_Address_ADD object:mapPoi];
            [sself.navigationController popViewControllerAnimated:YES];
        }else{
            [sself.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_Select_Address object:mapPoi];
        }
    };
    
    [self.view addSubview:searchView];
    [self.view addSubview:geoAddressView];
}

-(void)viewWillAppear:(BOOL)animated{
    self.search.delegate = self;
    _mapView.delegate = self;
    if (geoAddressView.hidden) {
        [self searchAddress];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    self.search.delegate = nil;
    _mapView.delegate = nil;
}

#pragma mark ================== wo de =================
-(void)searchAddress{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
    request.keywords =  nil;
    request.types = _myTypeName;
    request.sortrule = 0;
    request.requireExtension = YES;
    [_search AMapPOIAroundSearch:request];
    NSLog(@"%@",_myTypeName);
}

-(void)clickDw:(UIButton*)but{
    [searchBar endEditing:YES];
    geoAddressView.hidden = YES;
    if (!_selectCityView) {
        _selectCityView = [SelectCityView new];
        weakify(self);
        _selectCityView.selectBlcok = ^(NSString * city){
            strongify(self);
            self.selectCityView.hidden  = YES;
            self.loctionCityName = city;
            [but setTitle:[NSString stringWithFormat:@"%@▲",self.loctionCityName] forState:NO];
            [self geoWithAddressName:self.loctionCityName];
        };
        [self.view addSubview:_selectCityView];
    }
    _selectCityView.hidden = !_selectCityView.hidden;
    
    if (_selectCityView.hidden) {
        [but setTitle:[NSString stringWithFormat:@"%@▲",_loctionCityName] forState:NO];
    }else{
        [but setTitle:[NSString stringWithFormat:@"%@▼",_loctionCityName] forState:NO];
    }
}

-(void)geoWithAddressName:(NSString*)name{
    NSLog(@"geo 搜索：%@",name);
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = name;
    [self.search AMapGeocodeSearch:geo];
}

-(void)searchPoiByKeyword:(NSString*)name{
    NSLog(@"poi 搜索：%@",name);
    AMapPOIKeywordsSearchRequest *geo = [[AMapPOIKeywordsSearchRequest alloc] init];
    geo.keywords = name;
    geo.requireSubPOIs = YES;
     geo.cityLimit = YES; /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    [self.search AMapPOIKeywordsSearch:geo];
}

-(void)backLocation{
    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
}
-(void)endSearch{
    [searchBar endEditing:YES];
    geoAddressView.hidden = YES;
    
}

#pragma mark ================== seach Bar delegate =================
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1{
    [searchBar setShowsCancelButton:YES];
    for (UIView *view in [[searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitleColor:[UIColor blackColor] forState:NO];
            [cancelBtn addTarget:self action:@selector(endSearch) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1{
    [searchBar setShowsCancelButton:NO];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    geoAddressView.hidden = NO;
    _selectCityView.hidden = YES;
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchPoiByKeyword:searchText];
}

#pragma mark ================== map delegate =================
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (geoAddressView.hidden) {
        [self searchAddress];
    }
}

- (void)mapViewDidFinishLoadingMap:(MAMapView *)mapView{
//    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation) {
//        [_mapView setUserTrackingMode:MAUserTrackingModeNone animated:NO];
    }
}
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败");
}

#pragma mark ================== search delegate =================
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{

    if (geoAddressView.hidden) {
        searchView.dataArray = response.pois;
    }else{
        [geoAddressView showWithData:(NSMutableArray*)response.pois];
    }
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    if (response.geocodes.count > 0){
        AMapGeocode * geo = response.geocodes[0];
        [_mapView setCenterCoordinate:(CLLocationCoordinate2DMake(geo.location.latitude, geo.location.longitude)) animated:YES];
        _mapView.zoomLevel = 15;
    }
}


#pragma mark ================== super =================

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _mapView.delegate = nil;
    _search.delegate = nil;
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
