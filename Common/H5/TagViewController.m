//
//  TagViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/7.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "TagViewController.h"
#import "RootManager.h"


@interface TagViewController ()

@end

@implementation TagViewController

- (NSString *)requestURLString {
    [Utils addCookiesForURL:[NSURL URLWithString:H5_TAG_URL]];
    return H5_TAG_URL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    BOOL isFist = [[NSUserDefaults standardUserDefaults] boolForKey:NoFistSelectTag];
//    if (isFist == YES) {
//        UIButton * but = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        [but setTitle:@"跳转" forState:NO];
//        but.tintColor = [UIColor blackColor];
//        [but setTitleColor:[UIColor rgb:@"5cb531"] forState:NO];
//        but.frame = CGRectMake(self.view.width-80, 50, 60, 30);
//        [but addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:but];
//    }
    
}

-(void)dismiss{
//    [AppDelegate APP].window.rootViewController = [RootManager sharedManager].tabbarController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
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
