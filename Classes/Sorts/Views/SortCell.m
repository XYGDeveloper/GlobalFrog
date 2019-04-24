//
//  SortCell.m
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "SortCell.h"
#import "SortListItem.h"
#define SUB_SORT_BUTTON_HEIGHT 23.0

@interface SortCell ()

@property (nonatomic, strong) UIImageView *sortImgView;
@property (nonatomic, strong) UIButton *sortImgButton;

@property (nonatomic, strong) UILabel *sortNameLabel;

@property (nonatomic, strong) UIView *subSortView;

@end

@implementation SortCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.sortImgView];
        [self.contentView addSubview:self.sortImgButton];
        [self.contentView addSubview:self.sortNameLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self configLayout];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.subSortView removeAllSubViews];
    if (self.subSortView.superview) {
        [self.subSortView removeFromSuperview];
    }
}

#pragma mark - Public Mehtods
- (void)refreshWithSortItem:(SortListItem *)sortItem {
    
    self.sortImgButton.sortItem = sortItem;
   
    [self.sortImgView sd_setImageWithURL:[NSURL URLWithString:sortItem.cat_img] placeholderImage:[UIHelper bigPlaceholder]];
    self.sortNameLabel.text = sortItem.cat_name;
    
    [self configSubSort:sortItem.child];
}

+ (CGFloat)heithForSortItem:(SortListItem *)sortItem {
    CGFloat imgHeight = 160.0 * kScreenWidth / 375.0;
    
    CGFloat hMargin = 10.0;
    CGFloat vMargin = 16.0;
    CGFloat hPadding = 21.0;
    CGFloat vPadding = 14.0;
    
    CGFloat xPos = hMargin;
    CGFloat yPos = vMargin;
    for (int i = 0; i < sortItem.child.count; i ++) {
        SortListItem *item = [sortItem.child safeObjectAtIndex:i];
        UIButton *button = [self generalButtonWithSort:item];
        
        if (xPos + button.width > kScreenWidth - hMargin) {
            xPos = hMargin;
            yPos += (button.height + vPadding);
        }
        
        button.origin = CGPointMake(xPos, yPos);
        xPos = button.right + hPadding;
    }
    
    CGFloat subSortHeight = yPos + SUB_SORT_BUTTON_HEIGHT + vMargin;
    
    return imgHeight + subSortHeight;
}



#pragma mark - Events
- (void)sortButtonClicked:(UIButton *)sender {
    if (self.sortJumpBlock) {
        self.sortJumpBlock(sender.sortItem);
    }
}

#pragma mark - Layout
- (void)configLayout {
    
    CGFloat imgHeight = 160.0 * kScreenWidth / 375.0;
    self.sortImgView.frame = CGRectMake(0, 0, self.contentView.width, imgHeight);
    self.sortImgButton.frame = self.sortImgView.frame;
    self.sortNameLabel.frame = CGRectMake(0, 0.5*(self.sortImgView.height - 20), self.contentView.width, 20.0);
    self.subSortView.origin = CGPointMake(0, self.sortImgView.bottom);
}

#pragma mark - Pravite Methods
- (void)configSubSort:(NSArray *)subArray {
    CGFloat hMargin = 10.0;
    CGFloat vMargin = 16.0;
    CGFloat hPadding = 21.0;
    CGFloat vPadding = 14.0;
    
    
    CGFloat xPos = hMargin;
    CGFloat yPos = vMargin;
    for (int i = 0; i < subArray.count; i ++) {
        SortListItem *item = [subArray safeObjectAtIndex:i];
        UIButton *button = [[self class] generalButtonWithSort:item];
        [button addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (xPos + button.width > kScreenWidth - hMargin) {
            xPos = hMargin;
            yPos += (button.height + vPadding);
        }
        
        button.origin = CGPointMake(xPos, yPos);
        xPos = button.right + hPadding;
        [self.subSortView addSubview:button];
    }
    
    self.subSortView.origin = CGPointMake(0, self.sortImgView.bottom);
    self.subSortView.size = CGSizeMake(kScreenWidth, yPos + SUB_SORT_BUTTON_HEIGHT + vMargin);
    [self.contentView addSubview:self.subSortView];
}

+ (UIButton *)generalButtonWithSort:(SortListItem *)item {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.titleLabel.font = Font(12);
    [btn setTitle:item.cat_name forState:UIControlStateNormal];
    [btn setTitleColor:TextColor1 forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    btn.layer.cornerRadius = 2.0;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = HexColor(0xe6e6e6).CGColor;
    btn.layer.borderWidth = 0.5;
    
    btn.sortItem = item;
    [btn sizeToFit];
    btn.size = CGSizeMake(btn.width + 10, SUB_SORT_BUTTON_HEIGHT);
    
    
    return btn;
}

#pragma mark - Properties
- (UIImageView *)sortImgView {
    if (!_sortImgView) {
        _sortImgView = [[UIImageView alloc] init];
        _sortImgView.clipsToBounds = YES;
        _sortImgView.contentMode = UIViewContentModeScaleAspectFill;
        _sortImgView.userInteractionEnabled = YES;
    }
    return _sortImgView;
}

- (UIButton *)sortImgButton {
    if (!_sortImgButton) {
        _sortImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sortImgButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_sortImgButton setBackgroundImage:[UIImage imageWithColor:HexColorA(0x666666, 0.3)] forState:UIControlStateHighlighted];
        [_sortImgButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortImgButton;
}

- (UILabel *)sortNameLabel {
    if (!_sortNameLabel) {
        _sortNameLabel = GeneralLabelA(BFont(15), [UIColor whiteColor], NSTextAlignmentCenter);
    }
    return _sortNameLabel;
}

- (UIView *)subSortView {
    if (!_subSortView) {
        _subSortView = [[UIView alloc] init];
        _subSortView.backgroundColor = [UIColor whiteColor];
    }
    return _subSortView;
}

@end





@implementation UIButton (Sort)

static const char SortItemkey = '\0';

- (void)setSortItem:(SortListItem *)sortItem {
    if (sortItem != self.sortItem) {
        [self willChangeValueForKey:@"sortItem"];
        objc_setAssociatedObject(self, &SortItemkey, sortItem, OBJC_ASSOCIATION_RETAIN);
        [self didChangeValueForKey:@"sortItem"];
    }
}

- (SortListItem *)sortItem {
    return objc_getAssociatedObject(self, &SortItemkey);
}

@end
