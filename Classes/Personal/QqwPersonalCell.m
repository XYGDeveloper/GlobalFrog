//
//  QqwPersonalCell.m
//  Qqw
//
//  Created by 全球蛙 on 16/7/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "QqwPersonalCell.h"
#import "OrderCountModel.h"
@interface QqwPersonalCell ()

@end

@implementation QqwPersonalCell

-(instancetype)init
{
    if (self=[super init])
    {
        
        [self initView];
    }
 return self;
}

-(void)layoutSubviews
{
    [self initView];
}

-(void)initView
{
    [self removeAllSubViews];
    
    CGFloat btnWidth = 70.0f;
    CGFloat btnHeight = 60.0f;
    CGFloat gap = (kScreenWidth - 4 * btnWidth) / 5.0f;
    
    NSArray * titles = @[@"待付款", @"待发货", @"待收货", @"待评价"];
    NSArray * imageNames = @[@"0-1", @"0-2", @"0-3", @"0-4"];
    
    for (int i = 0; i < 4; i++)
    {
        CGFloat x = i * btnWidth + gap * ( i + 1);
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(x,5,btnWidth,btnHeight)];
        button.imageView.contentMode = UIViewContentModeCenter;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0,10,30,10)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.size.height+15,-button.imageView.size.width-30,0,0)];
        [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button setTitleColor:HexColorA(0x323232,0.6) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
        button.tag = i;
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
       
        
        //添加徽标
        
        if ([User hasLogin]) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x+btnWidth/4*2-2, 3, 16, 16)];
            label.backgroundColor = HexColor(0xd63d3e);
            [self addSubview:label];
            label.adjustsFontSizeToFitWidth = YES;
            label.tag = i+1000;
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10.0f];
            label.layer.cornerRadius = 8;
            label.layer.masksToBounds = YES;
        }
        
    }
         self.wailtToPayLabel = (UILabel *)[self viewWithTag:1000];
         self.wailtToSendLabel = (UILabel *)[self viewWithTag:1001];
         self.wailtToReceLabel = (UILabel *)[self viewWithTag:1002];
         self.wailtToCommentLabel = (UILabel *)[self viewWithTag:1003];

    if ([self.model.unpay isEqualToString:@"0"] || self.model.unpay == nil ) {
        self.wailtToPayLabel.backgroundColor =[UIColor clearColor];
    }else if (self.model.unpay.intValue>100){
        self.wailtToPayLabel.text = @"99+";
    }
    else{
        self.wailtToPayLabel.text = self.model.unpay;
    }
    
    if ([self.model.unsend isEqualToString:@"0"] || self.model.unsend == nil) {
        self.wailtToSendLabel.backgroundColor =[UIColor clearColor];
    }else if (self.model.unsend.intValue>100){
        self.wailtToPayLabel.text = @"99+";
    }else
    {
        self.wailtToSendLabel.text = self.model.unsend;
    }
    
    if ([self.model.sended isEqualToString:@"0"] || self.model.sended == nil) {
        self.wailtToReceLabel.backgroundColor =[UIColor clearColor];
    }else if (self.model.sended.intValue>100){
        self.wailtToPayLabel.text = @"99+";
    }else
    {
        self.wailtToReceLabel.text = self.model.sended;
    }
    
    if ([self.model.unevaluate isEqualToString:@"0"] || self.model.unevaluate == nil) {
        self.wailtToCommentLabel.backgroundColor =[UIColor clearColor];
    }else if (self.model.unevaluate.intValue>100){
        self.wailtToPayLabel.text = @"99+";
    }else
    {
        self.wailtToCommentLabel.text = self.model.unevaluate;
    }
    
}

-(void)btnAction:(UIButton*)btn
{
    if (self.btnAction) {
        self.btnAction(btn.tag);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)setModel:(OrderCountModel *)model
{
    _model = model;
    NSLog(@"model:%@",model.unsend);
    
}




@end
