//
//  SelectAddressController.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/6.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "SelectAddressController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "AddAddressViewController.h"
#import "MapViewController.h"
#import "LocationAddressView.h"
#import "SelectCityView.h"
#import "GeoAddressView.h"


@interface SelectAddressController ()<AMapSearchDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    UISearchBar *searchBar;
    NSString * _loctionAddress;
    GeoAddressView * geoAddressView;

    UIBarButtonItem * rightBarItem;
    
    CLLocation *_currentLocation;

}

@property (nonatomic, strong) NSMutableArray<AMapPOI *> *dataArray;

@property(nonatomic,strong)AMapSearchAPI * search;

@property(nonatomic,strong) SelectCityView * selectCityView;

@property(nonatomic,strong) UIButton * cityButton;


@end

@implementation SelectAddressController
-(void)back{
    [searchBar endEditing:YES];
    geoAddressView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
  
}

-(void)clickDw:(UIButton*)but{
    [self.view endEditing:YES];
    [searchBar endEditing:YES];
    if (!_selectCityView) {
        _selectCityView = [SelectCityView new];
        weakify(self);
        _selectCityView.selectBlcok = ^(NSString * city){
            strongify(self);
            self.selectCityView.hidden  = YES;
            self.loctionCityName = city;
            [but setTitle:[NSString stringWithFormat:@"%@▲",self.loctionCityName] forState:NO];

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择收获地址";
    _dataArray = [[NSMutableArray alloc]initWithCapacity:5];
    UIButton *backButton = [self navigationButtonWithImage:[UIImage imageNamed:@"nav_back"] highligthtedImage:nil action:@selector(back)];
    [self setLeftNavigationItems:@[backButton]];
    
    [self location];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,44)];
    searchBar.placeholder = @"小区/写字楼/学校等";
    searchBar.backgroundImage = [UIImage imageNamed:@"bk_writh"];
    searchBar.delegate = self;
    UITextField *searchField=[searchBar valueForKey:@"_searchField"];
    searchField.backgroundColor =RGB(243, 243, 243);
    self.navigationItem.titleView = searchBar;
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(@0);
    }];
    
    geoAddressView = [GeoAddressView new];
    geoAddressView.hidden = YES;
    [self.view addSubview:geoAddressView];
    
//    UIButton * but = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    but.tintColor = AppStyleColor;
//    but.frame = CGRectMake(0, 0, 60, 30);
//    [but setTitle:@"添加地址" forState:NO];
//    [but addTarget:self action:@selector(clickAddAddress) forControlEvents:UIControlEventTouchUpInside];
//    but.titleLabel.font = [UIFont systemFontOfSize:14];
//    rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:but];
    
}

#pragma mark ================== jiao hu =================
-(void)clickAddAddress{
    [self endSearch];
    AddAddressViewController * add  = [[AddAddressViewController alloc]initWithStyle:(UITableViewStyleGrouped)];
    add.freshAddressType = FreshAddressType_Add;

    [self.navigationController pushViewController:add animated:YES];
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
    _selectCityView.hidden = YES;
    geoAddressView.hidden = NO;
//     self.navigationItem.rightBarButtonItem = nil;
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchPoiByKeyword:searchText];
}

#pragma mark  ================== Table view data source  ==================
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    v.backgroundColor = RGB(240, 240, 240);
    
    UILabel * l = [[UILabel alloc]initWithFrame:CGRectMake(13, 10, v.width, 30)];
    l.font = [UIFont systemFontOfSize:15];
    l.textColor = [UIColor grayColor];
    switch (section) {
        case 0:
            l.text = @"当前位置";
            break;

        case 1:
            l.text = @"附近地址";
            break;
        default:
            break;
    }
    [v addSubview:l];
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }
    return _dataArray.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString * celliden = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celliden];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:celliden];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = _loctionAddress;
        UIButton * b = [cell viewWithTag:10000];
        if (!b) {
            b = [UIButton buttonWithType:(UIButtonTypeSystem)];
            [b setTitle:@" 重新定位" forState:NO];
            [b setImage:[UIImage imageNamed:@"dw38"] forState:NO];
            b.tintColor = AppStyleColor;
            b.userInteractionEnabled = NO;
            b.titleLabel.font = [UIFont systemFontOfSize:14];
            b.tag = 10000;
            [cell addSubview:b];
            [b mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-20));
                make.top.equalTo(@(5));
                make.bottom.equalTo(@(-5));
            }];
        }

        return cell;
        
    }
    
    static NSString * celliden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celliden];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:celliden];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.row == _dataArray.count) {
        cell.textLabel.text = @"更多地址";
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = 1;
        return cell;
    }
    cell.accessoryType = 0;
    cell.textLabel.textColor = [UIColor lightGrayColor];
    AMapPOI * a = _dataArray[indexPath.row];
    cell.textLabel.text = a.name;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section== 1&&indexPath.row == _dataArray.count) {
        MapViewController * ma = [MapViewController new];
        ma.loctionCityName = _loctionCityName;
        [self.navigationController pushViewController:ma animated:YES];
    }else if (indexPath.section == 0){
        [self location];
    }else{
        AMapPOI * a = _dataArray[indexPath.row];
        [Utils popBackFreshWithObj:a view:self.view];
    }
}

#pragma mark ================== search delegate =================
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{

    if ([request isMemberOfClass:[AMapPOIAroundSearchRequest class]]) {
        [_dataArray removeAllObjects];
        if (response.pois.count>5) {
            for (int i = 0; i<5; i++) {
                [_dataArray addObject:response.pois[i]];
            }
        }else{
            _dataArray = (NSMutableArray*)response.pois;

        }
        [self.tableView reloadData];
    }else{
        [geoAddressView showWithData:(NSMutableArray*)response.pois];
    }
   
}

#pragma mark ================== wo de ===============
-(void)endSearch{
    [searchBar endEditing:YES];
    geoAddressView.hidden = YES;
//     self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)location {
    [[LocationManager sharedManager]startLocationUpdateLocation:^(CLLocation *tmpLocation) {
        _currentLocation = tmpLocation;
        [self seachAddress:nil location:_currentLocation];
    } Success:^(CLPlacemark *placeMark) {
        _loctionAddress = placeMark.name;
//        self.navigationItem.rightBarButtonItem = rightBarItem;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)seachAddress:(NSString*)str location:(CLLocation*)location{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    request.keywords = str?:@"";
    request.requireExtension = YES;
    request.types = @"";
    request.sortrule = 0;
    [_search AMapPOIAroundSearch:request];
}

-(void)searchPoiByKeyword:(NSString*)name{
    NSLog(@"poi 搜索：%@",name);
    AMapPOIKeywordsSearchRequest *geo = [[AMapPOIKeywordsSearchRequest alloc] init];
    geo.keywords = name;
    geo.requireSubPOIs = YES;
    geo.cityLimit = YES; /*只搜索本城市的POI。*/
    [self.search AMapPOIKeywordsSearch:geo];
}

#pragma mark ================== super =================
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    _search = nil;

}

@end
