//
//  QQWSearchBar.m
//  Qqw
//
//  Created by zagger on 16/9/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "QQWSearchBar.h"

@implementation QQWSearchBar

- (id)init {
    
    self = [super init];
    if ( self ) {
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]];
        
        UIImage *searchBackgroundImage = [UIImage imageWithRoundedCornersSize:5.0 usingImage:[UIImage imageWithColor:RGB(244, 244, 244) size:CGSizeMake(100.0, 28.0)]];
        [self setSearchFieldBackgroundImage:searchBackgroundImage  forState:UIControlStateNormal];
        
        self.tintColor = AppStyleColor;
        self.searchTextPositionAdjustment = UIOffsetMake(10, 0);
        
        [self setImage:[UIImage imageNamed:@"nav_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        UITextField *searchTextField = [self valueForKey:@"_searchField"];
        if ([searchTextField isKindOfClass:[UITextField class]]) {
            searchTextField.font = Font(13);
            searchTextField.textColor = TextColor1;
        }
    }
    return self;
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    UITextField *searchTextField = [self valueForKey:@"_searchField"];
    if ([searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        [searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: TextColor3}]];
    }
}

@end
