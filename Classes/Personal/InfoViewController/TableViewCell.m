//
//  TableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/17.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

  self =   [super initWithStyle:style reuseIdentifier:reuseIdentifier];
   
    if (self) {
        
        self.headImg = [[UIImageView alloc]init];
        self.headImg.layer.cornerRadius = 30;
        self.headImg.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImg];
        self.nikeName = [[UILabel alloc]init];
        [self.contentView addSubview:_nikeName];
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = RGB(220, 220, 220);
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];
        
        self.commentContent = [[UILabel alloc]init];
        self.commentContent.numberOfLines = 0;
        self.commentContent.textColor = RGB(150, 150, 150);
        [self.contentView addSubview:_commentContent];
        
        self.arctile_img = [[UIImageView alloc]init];
        
        [self.contentView addSubview:_arctile_img];
        
        self.arctile_content = [[UILabel alloc]init];
        self.arctile_content.backgroundColor = RGB(243, 243, 243);
        self.arctile_content.textColor = RGB(86, 86, 86);
        self.arctile_content.numberOfLines = 0;
        [self.contentView addSubview:_arctile_content];
        
        self.comment = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.comment setBackgroundImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [self.contentView addSubview:_comment];
        
        [self.comment addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;


}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    [self.headImg whc_TopSpace:5];
    [self.headImg whc_LeftSpace:5];
    [self.headImg whc_Width:60];
    [self.headImg whc_Height:60];
   
    [self.nikeName whc_LeftSpace:5 relativeView:self.headImg];
    [self.nikeName whc_TopSpace:5];
    [self.nikeName whc_RightSpace:30];
    [self.nikeName whc_Height:20];
    
    [self.comment whc_LeftSpace:0 relativeView:self.nikeName];
    [self.comment whc_TopSpace:5];
    [self.comment whc_Width:20];
    [self.comment whc_Height:20];
    
    [self.timeLabel whc_LeftSpace:5 relativeView:self.headImg];
    [self.timeLabel whc_TopSpace:3 relativeView:self.nikeName];
    [self.timeLabel whc_RightSpace:10];
    [self.timeLabel whc_Height:20];
    
    [self.commentContent whc_LeftSpace:5];
    [self.commentContent whc_TopSpace:3 relativeView:self.headImg];
    [self.commentContent whc_RightSpace:10];
    [self.commentContent whc_HeightAuto];
  
    [self.arctile_img whc_LeftSpace:5];
    [self.arctile_img whc_TopSpace:3 relativeView:self.commentContent];
    [self.arctile_img whc_Width:80];
    [self.arctile_img whc_Height:80];
    
    [self.arctile_content whc_LeftSpace:0 relativeView:self.arctile_img];
    [self.arctile_content whc_TopSpace:5 relativeView:self.commentContent];
    [self.arctile_content whc_RightSpace:10];
    [self.arctile_content whc_Height:80];
    
}



- (void)commentAction
{

    self.commentBlock();

}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
