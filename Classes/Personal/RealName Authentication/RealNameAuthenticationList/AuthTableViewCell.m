//
//  AuthTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/16.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "AuthTableViewCell.h"

@implementation AuthTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setRealListModel:(RealListModel *)realListModel{
    _realListModel = realListModel;
    _nameLabel.text = realListModel.realname;
    NSString *endString = [realListModel.card_number stringByReplacingCharactersInRange:NSMakeRange(3, 11) withString:@"***********"];
    _numLabel.text = [NSString stringWithFormat:@"身份证 %@",endString];
    if (realListModel.is_default.intValue == 0) {
        [_selectBut setImage:[UIImage imageNamed:@"identityDefaultButtonState"] forState:NO];
    }else{
        [_selectBut setImage:[UIImage imageNamed:@"identityDefaultButtonState_selected"] forState:NO];
    }
}

- (IBAction)clickSelectBut:(UIButton *)sender {
    if (self.setDefaultRealName) {
        
        self.setDefaultRealName();
    }
}

- (IBAction)clickDeletBut:(UIButton *)sender {
    if (self.toDelete) {
        self.toDelete();
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
