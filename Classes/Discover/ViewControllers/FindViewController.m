//
//  FindViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/1.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "FindViewController.h"

@interface FindViewController ()

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    self.openURLInNewController = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChange) name:kLoginSuccessNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChange) name:kLogoutSuccessNotify object:nil];
    [self loadRequest];
}

-(NSString *)requestURLString{
    return  H5_FINDINDEX_URL;
}

-(void)loadRequest{
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5_FINDINDEX_URL]]];
}

#pragma mark ================== noty =================
-(void)loginChange{
    [self loadRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
