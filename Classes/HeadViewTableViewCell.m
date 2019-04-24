//
//  HeadViewTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 2017/4/5.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "HeadViewTableViewCell.h"
#import "QqwPersonalDataEditController.h"
#import "ShopCollectViewController.h"
#import "QqwAttentionViewController.h"
#import "MyInfoViewController.h"
@implementation HeadViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImgView.layer.cornerRadius = 30;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchHeadView:)];
    [_headImgView addGestureRecognizer:tap];
}

-(void)setOrderCountModel:(OrderCountModel *)orderCountModel{
    _orderCountModel = orderCountModel;
     if ([User hasLogin]== YES) {
         [_headImgView sd_setImageWithURL:[NSURL URLWithString:[User LocalUser].face] placeholderImage:[UIImage imageNamed:@"HEADER"]];
         _nameLabel.text = [User LocalUser].nickname;

         _msgLabel.text = [User LocalUser].butler_name;
         
         [_cxBut setTitle:[NSString stringWithFormat:@"收藏 %@",orderCountModel.collections] forState:UIControlStateNormal];
         [_gzBut setTitle:[NSString stringWithFormat:@"关注 %@",orderCountModel.follows] forState:UIControlStateNormal];
     }else{
         _headImgView.image = [UIImage imageNamed:@"HEADER"];
         _nameLabel.text = nil;
         _msgLabel.text = @"登录/注册";
         [_cxBut setTitle:@"收藏" forState:UIControlStateNormal];
         [_gzBut setTitle:@"关注" forState:UIControlStateNormal];
     }

}

- (void)touchHeadView:(id)sender {
    if (![Utils showLoginPageIfNeeded]) {
        UINavigationController * nav = [RootManager sharedManager].tabbarController.selectedViewController;
        QqwPersonalDataEditController *edit = [[QqwPersonalDataEditController alloc]init];
        [nav pushViewController:edit animated:YES];
    }
}


- (IBAction)clickSCBut:(id)sender {
    if (![Utils showLoginPageIfNeeded]) {
        UINavigationController * nav = [RootManager sharedManager].tabbarController.selectedViewController;
        ShopCollectViewController *shopCollect = [[ShopCollectViewController alloc]init];
        shopCollect.title = @"我的收藏";
        [nav pushViewController:shopCollect animated:YES];
    }
}

- (IBAction)clickGZBut:(id)sender {
    if (![Utils showLoginPageIfNeeded]) {
        UINavigationController * nav = [RootManager sharedManager].tabbarController.selectedViewController;
        QqwAttentionViewController *attention = [[QqwAttentionViewController alloc]init];
        attention.title = @"我的关注";
        [nav pushViewController:attention animated:YES];
    }
}

- (IBAction)clickInfoBut:(UIButton *)sender {
    if (![Utils showLoginPageIfNeeded]) {
            UINavigationController * nav = [RootManager sharedManager].tabbarController.selectedViewController;
        MyInfoViewController *myInfo = [MyInfoViewController new];
        [nav pushViewController:myInfo animated:YES];

    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
