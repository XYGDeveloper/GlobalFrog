//
//  MemberViewController.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "MemberViewController.h"

@interface MemberViewController ()

@property (weak, nonatomic) IBOutlet UIButton *memberButton;

@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    self.memberButton.layer.cornerRadius = 20;
    
    
    // Do any additional setup after loading the view from its nib.
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
