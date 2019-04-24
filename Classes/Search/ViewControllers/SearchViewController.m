//
//  SearchViewController.m
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "SearchViewController.h"
#import "GoodsModel.h"
#import "SearchGoodsCell.h"
#import "GoodsDetailViewController.h"
#import "QQWSearchBar.h"

@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    int _page;
    CLLocation *_currentLocation;
}

@property (nonatomic, strong) QQWSearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *hotTagView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation SearchViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray new];
    
    self.navigationItem.titleView = self.searchBar;
    _page = 1;
    [self setRightNavigationItemWithTitle:@"搜索" action:@selector(searchButtonClicked:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureOnHotTagView:)];
    [self.hotTagView addGestureRecognizer:tap];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.hotTagView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    [self.hotTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    __weak SearchViewController * ss = self;
    [GoodsModel requestHotTagWithType:_searchType superView:nil finshBlock:^(id obj, NSError *error) {
          [ss.hotTagView addTagLabels:obj target:ss action:@selector(hotTagButtonClicked:)];
    }];
    
}

#pragma mark - Events
- (void)searchButtonClicked:(id)sender {
    NSString *keyword = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (keyword.length > 0) {
        [self.searchBar endEditing:YES];
        [GoodsModel requestSearchWithString:keyword type:_searchType page:_page lat:_currentLocation.coordinate.latitude lng:_currentLocation.coordinate.longitude superView:self.view finshBlock:^(id obj, NSError *error) {
            self.dataArray = obj;
            self.hotTagView.hidden = YES;
            [self.tableView reloadData];
            if (self.dataArray.count <= 0) {
                [[EmptyManager sharedManager] showEmptyOnView:self.view withImage:[UIImage imageNamed:@"search_empty"] explain:@"抱歉，没有找到商品额~" operationText:nil operationBlock:nil];
                [self.view insertSubview:self.hotTagView atIndex:2];
            } else {
                [[EmptyManager sharedManager] removeEmptyFromView:self.view];
            }
        }];
        
    }
}

- (void)hotTagButtonClicked:(UIButton *)sender {
    NSString *title = [sender titleForState:UIControlStateNormal];
    self.searchBar.text = title;
    [self searchButtonClicked:nil];
}

- (void)tapGestureOnHotTagView:(UITapGestureRecognizer *)tap {
    [self.searchBar endEditing:YES];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.hotTagView.hidden = NO;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.hotTagView.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchButtonClicked:nil];
}


#pragma mark - UITableViewDataSource & UISearchBarDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchGoodsCell *cell = (SearchGoodsCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchGoodsCell class])];
    
    GoodsModel *goodsModel = [self.dataArray safeObjectAtIndex:indexPath.row];
    [cell refreshWithSearchGoodsModel:goodsModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsModel *goodsModel = [self.dataArray safeObjectAtIndex:indexPath.row];
    
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] initWithGoodsIdentifier:goodsModel.goods_id];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Properties
- (QQWSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[QQWSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"输入关键字";
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        _tableView.separatorInset = UIEdgeInsetsZero;
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            _tableView.layoutMargins = UIEdgeInsetsZero;
        }
        if ([_tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
            _tableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
        [_tableView registerClass:[SearchGoodsCell class] forCellReuseIdentifier:NSStringFromClass([SearchGoodsCell class])];
    }
    return _tableView;
}

- (UIView *)hotTagView {
    if (!_hotTagView) {
        _hotTagView = [[UIView alloc] init];
        _hotTagView.backgroundColor = [UIColor whiteColor];
    }
    return _hotTagView;
}

@end
