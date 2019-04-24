//
//  SelectCityView.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/17.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "SelectCityView.h"

#define StartLoction @"定位中...."
#define ErrorLoction @"定位失败"
static NSString * loctionStr = @"定";

@implementation SelectCityView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height-64)];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        [self addSubview:_tabelView];
        
        leftKeyArrat = [NSMutableArray new];
        NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                       ofType:@"plist"];
        _cityDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        [leftKeyArrat addObjectsFromArray:[[self.cityDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)]];
        
        _tabelView.sectionIndexColor = AppStyleColor;

        [leftKeyArrat insertObject:loctionStr atIndex:0];
        [_cityDictionary setObject:@[StartLoction] forKey:loctionStr];
        [self startLocation];
    }
    return self;
}

#pragma mark ================== wode =================
- (void)startLocation {
    [[LocationManager sharedManager]startLocationUpdateLocation:nil Success:^(CLPlacemark *placeMark) {
        if ([leftKeyArrat[0]isEqualToString:loctionStr]) {
            [leftKeyArrat removeObject:loctionStr];
            [self.cityDictionary  removeObjectForKey:loctionStr];
        }
        
        [leftKeyArrat insertObject:loctionStr atIndex:0];
        [self.cityDictionary setObject:@[placeMark.locality] forKey:loctionStr];
        
        [_tabelView reloadData];
    } failure:^(NSError *error) {
        if ([leftKeyArrat[0]isEqualToString:loctionStr]) {
            [leftKeyArrat removeObject:loctionStr];
            [self.cityDictionary  removeObjectForKey:loctionStr];
        }
        
        [leftKeyArrat insertObject:loctionStr atIndex:0];
        [self.cityDictionary setObject:@[ErrorLoction] forKey:loctionStr];
    }];

}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return leftKeyArrat;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([leftKeyArrat[section] isEqualToString:loctionStr]) {
        return @"当前定位城市";
    }
    return leftKeyArrat[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return leftKeyArrat.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [leftKeyArrat objectAtIndex:section];
    NSArray *citySection = [self.cityDictionary objectForKey:key];
    return [citySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * celliden = @"seachCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celliden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:celliden];
    }
    NSString *key = [leftKeyArrat objectAtIndex:indexPath.section];
    NSArray *citySection = [self.cityDictionary objectForKey:key];
    cell.textLabel.text = citySection[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIButton * b = [cell viewWithTag:10000];
    if ([leftKeyArrat[indexPath.section] isEqualToString:loctionStr]) {
        if ([leftKeyArrat[indexPath.section] isEqualToString:ErrorLoction]) {
            cell.textLabel.textColor = [UIColor redColor];
        }
        
        if (!b) {
            b = [UIButton buttonWithType:(UIButtonTypeSystem)];
            [b setTitle:@" 重新定位" forState:NO];
            [b setImage:[UIImage imageNamed:@"dw38"] forState:NO];
            b.tintColor = AppStyleColor;
            [b addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
            b.titleLabel.font = [UIFont systemFontOfSize:14];
            b.tag = 10000;
            [cell addSubview:b];
            [b mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-20));
                make.top.equalTo(@(5));
                make.bottom.equalTo(@(-5));
            }];
        }
    }else{
        b.hidden = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_selectBlcok) {
        _selectBlcok(cell.textLabel.text);
    }
}

#pragma mark ================== supe =================
-(void)dealloc{
    
}
@end
