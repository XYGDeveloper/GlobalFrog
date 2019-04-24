//
//  ApplyAfterSaleViewController.m
//  Qqw
//
//  Created by zagger on 16/9/7.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "ApplyAfterSaleViewController.h"
#import "SZTextView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "SuccessViewController.h"

#import "OrderModel.h"
#import "AfterSaleApplyApi.h"
#import "AfterSaleTypeCell.h"
#import "AfterSaleTypeApi.h"

static NSInteger maxCount = 200;

@interface ApplyAfterSaleViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, ApiRequestDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;

//@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, strong) SZTextView *textView;

@property (nonatomic, strong) AfterSaleApplyApi *applyApi;

@property (nonatomic, strong) AfterSaleTypeApi *typeApi;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation ApplyAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请售后";
    [self setRightNavigationItemWithTitle:@"提交" action:@selector(submitButtonClicked:)];
    
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.submitButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);//.insets(UIEdgeInsetsMake(0, 0, 44.0, 0));
    }];
    
//    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(@0);
//        make.height.equalTo(@44);
//    }];
    
    self.tableView.tableFooterView = [self footerView];
    [Utils addHudOnView:self.view];
    [self.typeApi getAfteSaleType];
    
}


#pragma mark - Events
- (void)submitButtonClicked:(id)sender {
    [Utils addHudOnView:self.view];
    
    AfterSaleType *asType = [self.dataArray safeObjectAtIndex:self.selectedIndex];
    [self.applyApi applyWithOrder:self.afterSaleOrderId
                            goods:@[self.afterSaleGoods.goods_id?:@""]
                          product:@[self.afterSaleGoods.product_id?:@""]
                             type:asType.type
                          explain:self.textView.text];
}

#pragma mark - Pravite Methods
- (UIView *)footerView {
    self.textView.frame = CGRectMake(0, 0, kScreenWidth, 135.0);
    return self.textView;
}

#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [Utils removeHudFromView:self.view];
    
    if (api == self.applyApi) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kOrderStatusChangedNotify object:nil];
        
        SuccessViewController *vc = [SuccessViewController afterSaleApplySuccessViewControllerWithOrder:self.afterSaleOrderId];
        NSInteger count = self.navigationController.viewControllers.count;
        vc.popBackViewController = [self.navigationController.viewControllers safeObjectAtIndex:count -2];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (api == self.typeApi) {
        self.dataArray = responsObject;
        [self.tableView reloadData];
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
    
    if (api == self.typeApi) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.view response:command.response operationBlock:^{
            strongify(self)
            [Utils addHudOnView:self.view];
            [self.typeApi getAfteSaleType];
        }];
    }
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        return NO;
    } else if (!textView.markedTextRange && textView.text.length >= maxCount && text.length > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showMaxCountRemind) object:nil];
        [self performSelector:@selector(showMaxCountRemind) withObject:nil afterDelay:0.2];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (!textView.markedTextRange && textView.text.length > maxCount) {
        textView.text = [textView.text substringToIndex:maxCount];
        textView.contentOffset = CGPointZero;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showMaxCountRemind) object:nil];
        [self performSelector:@selector(showMaxCountRemind) withObject:nil afterDelay:0.2];
    }
}

- (void)showMaxCountRemind {
    [Utils postMessage:[NSString stringWithFormat:@"最多只能输入%ld个字", (long)maxCount] onView:self.view];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AfterSaleTypeCell *cell = (AfterSaleTypeCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AfterSaleTypeCell class])];
    AfterSaleType *asType = [self.dataArray safeObjectAtIndex:indexPath.row];
    [cell refreshWithType:asType selected:self.selectedIndex == indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
    
}



#pragma mark - Properties
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[AfterSaleTypeCell class] forCellReuseIdentifier:NSStringFromClass([AfterSaleTypeCell class])];
    }
    return _tableView;
}

//- (UIButton *)submitButton {
//    if (!_submitButton) {
//        _submitButton = [UIHelper generalButtonWithTitle:@"提交申请"];
//        [_submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _submitButton;
//}

- (SZTextView *)textView {
    if (!_textView) {
        _textView = [[SZTextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = Font(13);
        _textView.textColor = TextColor1;
        _textView.placeholder = [NSString stringWithFormat:@"申请说明（仅限%ld字）",(long)maxCount];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
    }
    return _textView;
}

- (AfterSaleApplyApi *)applyApi {
    if (!_applyApi) {
        _applyApi = [[AfterSaleApplyApi alloc] init];
        _applyApi.delegate = self;
    }
    return _applyApi;
}

- (AfterSaleTypeApi *)typeApi {
    if (!_typeApi) {
        _typeApi = [[AfterSaleTypeApi alloc] init];
        _typeApi.delegate = self;
    }
    return _typeApi;
}

@end
