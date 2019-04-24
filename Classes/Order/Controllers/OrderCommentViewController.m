//
//  OrderCommentViewController.m
//  Qqw
//
//  Created by zagger on 16/8/29.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "OrderCommentViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "OrderCommentCell.h"
#import "OrderModel.h"
#import "OrderCommentApi.h"
#import "SuccessViewController.h"

@interface OrderCommentViewController ()<UITableViewDelegate, UITableViewDataSource, ApiRequestDelegate>{
//    UITextView * currentTextView;
     NSInteger currentTextViewtag;
}

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic, strong) OrderCommentApi *cmtApi;

@property (nonatomic, strong) NSMutableArray *cmtArray;

@property (nonatomic, strong) CommentSubmitBar *submitBar;

//@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation OrderCommentViewController

- (id)initWithOrder:(OrderModel *)order {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.order = order;
        
        __weak typeof(self) wself = self;
        self.submitBar.submitBlock = ^ {
            __strong typeof(wself) sself = wself;
            [sself submitComments];
        };
        
        self.cmtArray = [[NSMutableArray alloc] initWithCapacity:self.order.goods_list.count];
        for (OrderGoodsModel *goodsModel in self.order.goods_list) {
            OrderCmtBuildModel *cmtModel = [[OrderCmtBuildModel alloc] init];
            cmtModel.goodsModel = goodsModel;
            cmtModel.star = 5;
            cmtModel.content = @"";
            [self.cmtArray addObject:cmtModel];
            
//            OrderCmtBuildModel *cmtModel1 = [[OrderCmtBuildModel alloc] init];
//            cmtModel1.goodsModel = goodsModel;
//            cmtModel1.star = 5;
//            cmtModel1.content = @"";
//            [self.cmtArray addObject:cmtModel1];
//           
//            OrderCmtBuildModel *cmtModel2 = [[OrderCmtBuildModel alloc] init];
//            cmtModel2.goodsModel = goodsModel;
//            cmtModel2.star = 5;
//            cmtModel2.content = @"";
//            [self.cmtArray addObject:cmtModel2];
//            
//            OrderCmtBuildModel *cmtModel3 = [[OrderCmtBuildModel alloc] init];
//            cmtModel3.goodsModel = goodsModel;
//            cmtModel3.star = 5;
//            cmtModel3.content = @"";
//            [self.cmtArray addObject:cmtModel3];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发表评论";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitBar];

    [self.submitBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@44.0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(self.submitBar.mas_top).offset(0);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark ================== noty =================
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [self.submitBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-height));
    }];
    [self.view layoutIfNeeded];
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:currentTextViewtag] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    [self.submitBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(0));
    }];
    [self.view layoutIfNeeded];
}

- (void)submitComments {
    [Utils addHudOnView:self.view];
    [self.cmtApi submitComment:self.cmtArray forOrder:self.order.order_sn anonymity:self.submitBar.isAnonymity];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cmtArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCommentCell *cell = (OrderCommentCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderCommentCell class])];
    
    OrderCmtBuildModel *cmtModel = [self.cmtArray safeObjectAtIndex:indexPath.section];
    cell.textView.tag  = 10000 + indexPath.section;
    cell.editTextViewBlock = ^(UITextView * textView){
        currentTextViewtag = textView.tag-10000;
    };
    [cell refreshWithCommentInfo:cmtModel];
    return cell;
}


#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOrderStatusChangedNotify object:nil];//订单状态改变通知
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SuccessViewController *vc = [SuccessViewController orderCommentSuccessViewController];
        NSInteger count = self.navigationController.viewControllers.count;
        vc.popBackViewController = [self.navigationController.viewControllers safeObjectAtIndex:count -2];
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
}

#pragma mark - Properties
- (OrderCommentApi *)cmtApi {
    if (!_cmtApi) {
        _cmtApi = [[OrderCommentApi alloc] init];
        _cmtApi.delegate = self;
    }
    return _cmtApi;
}

- (CommentSubmitBar *)submitBar {
    if (!_submitBar) {
        _submitBar = [[CommentSubmitBar alloc] init];
    }
    return _submitBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[OrderCommentCell class] forCellReuseIdentifier:NSStringFromClass([OrderCommentCell class])];
    }
    
    return _tableView;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommentSubmitBar ()

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UIButton *anonymityButton;

@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, assign, readwrite) BOOL isAnonymity;

@end

@implementation CommentSubmitBar

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.anonymityButton addTarget:self action:@selector(anonymityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.topLineView];
        [self addSubview:self.anonymityButton];
        [self addSubview:self.submitButton];
        
        [self configLayout];
    }
    
    return self;
}

#pragma mark - Events
- (void)anonymityButtonClicked:(id)sender {
    self.anonymityButton.selected = !self.anonymityButton.selected;
}

- (void)submitButtonClicked:(id)sender {
    if (self.submitBlock) {
        self.submitBlock();
    }
}

#pragma mark - Layout
- (void)configLayout {
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    [self.anonymityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.width.equalTo(@70);
        make.height.equalTo(@40);
        make.centerY.equalTo(self);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(@0);
        make.width.equalTo(@79);
        make.height.equalTo(@44);
    }];
}

#pragma mark - Properties
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = DividerDarkGrayColor;
    }
    return _topLineView;
}

- (UIButton *)anonymityButton {
    if (!_anonymityButton) {
        _anonymityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _anonymityButton.backgroundColor = [UIColor clearColor];
        
        [_anonymityButton setImage:[UIImage imageNamed:@"vip_sexUnselected"] forState:UIControlStateNormal];
        [_anonymityButton setImage:[UIImage imageNamed:@"vip_sexSelected"] forState:UIControlStateSelected];
        
        _anonymityButton.titleLabel.font = Font(12);
        [_anonymityButton setTitle:@"匿名评价" forState:UIControlStateNormal];
        [_anonymityButton setTitleColor:TextColor2 forState:UIControlStateNormal];
    }
    return _anonymityButton;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _submitButton.titleLabel.font = Font(13);
        [_submitButton setTitle:@"发表评价" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageWithColor:AppStyleColor] forState:UIControlStateNormal];
    }
    
    return _submitButton;
}

@end
