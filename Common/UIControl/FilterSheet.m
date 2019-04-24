//
//  FilterSheet.m
//  Qqw
//
//  Created by zagger on 16/9/9.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "FilterSheet.h"

@interface FilterSheet ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *trigView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign, readwrite) BOOL isShowing;

@end

@implementation FilterSheet

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.trigView.top = 0;
        self.trigView.right = self.width - 8.0;
        
        self.tableView.frame = CGRectMake(0, self.trigView.bottom, self.width, self.height - self.trigView.height);
        
        [self addSubview:self.trigView];
        [self addSubview:self.tableView];
        
        self.tableView.layer.cornerRadius = 2.0;
        self.tableView.layer.masksToBounds = YES;
        
        self.clipsToBounds = YES;
    }
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    
//}

#pragma mark - Public Methods
- (void)showOnView:(UIView *)parentView {
    if (self.isShowing || self.animating) {
        return;
    }
    if (!parentView) {
        parentView = [UIApplication sharedApplication].keyWindow;
    }
    
    CGRect frame = self.frame;
    CGRect zeroFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
    
    self.frame = zeroFrame;
    [parentView addSubview:self];
    
    self.animating = YES;
    self.isShowing = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
}

- (void)dismiss {
    if (!self.isShowing) {
        return;
    }
    
    CGRect frame = self.frame;
    CGRect zeroFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
    
    self.animating = YES;
    self.isShowing = NO;

    [UIView animateWithDuration:0.25 animations:^{
        self.frame = zeroFrame;
    } completion:^(BOOL finished) {
        self.animating = NO;
        if (self.superview) {
            [self removeFromSuperview];
            self.frame = frame;
        }
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 34.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterSheetCell *cell = (FilterSheetCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FilterSheetCell class])];
    
    [cell refreshWithName:[self.dataArray safeObjectAtIndex:indexPath.row] selected:indexPath.row == self.selectedIndex];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
    
    if (self.selectedChangedBlock) {
        self.selectedChangedBlock(self.selectedIndex);
    }
}


#pragma mark - Properties
- (UIImageView *)trigView {
    if (!_trigView) {
        _trigView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"brand_sortingTrig"]];
    }
    return _trigView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        [_tableView registerClass:[FilterSheetCell class] forCellReuseIdentifier:NSStringFromClass([FilterSheetCell class])];
    }
    return _tableView;
}

@end






@interface FilterSheetCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *indicatorView;

@end

@implementation FilterSheetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = DefaultBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self configLayout];
    }
    return self;
}

- (void)refreshWithName:(NSString *)name selected:(BOOL)selected {
    self.nameLabel.text = name;
    self.indicatorView.hidden = !selected;
}



#pragma mark - Layout
- (void)configLayout {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.indicatorView];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - Properties
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = GeneralLabel(Font(12), TextColor1);
    }
    return _nameLabel;
}

- (UIImageView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"brand_sortingMarker"]];
    }
    return _indicatorView;
}

@end