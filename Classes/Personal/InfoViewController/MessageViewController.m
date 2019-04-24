//
//  MessageViewController.m
//  Qqw
//
//  Created by xyg on 2016/12/24.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "MessageViewController.h"
#import "KeyboardInputView.h"
#import "ChatModel.h"
@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSouce;

@property (nonatomic,strong) KeyboardInputView *inputView;
@end

@implementation MessageViewController

static NSString *leftCell = @"leftCell";
static NSString *rightCell = @"rightCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.inputView = [[KeyboardInputView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 64 - 40, kScreenWidth, 40)];
    self.inputView.backgroundColor = [UIColor whiteColor];
    self.inputView.textField.returnKeyType = UIReturnKeySend;
    self.inputView.textField.delegate = self;
    [self.inputView.button addTarget:self action:@selector(clickSengMsg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@40);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MessgeRightTableViewCell" bundle:nil] forCellReuseIdentifier:rightCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessgeLeftTableViewCell" bundle:nil] forCellReuseIdentifier:leftCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = DefaultBackgroundColor;
    self.view.backgroundColor = DefaultBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(self.inputView.mas_top).offset(0);
    }];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _dataSouce = [[NSMutableArray alloc] init];
    
    [ChatModel requestMsgListWithMid:@"0" uid:self.uid page:1 dataArray:_dataSouce superView:nil finshBlock:^(id obj, NSError *error) {
        [self.tableView reloadData];
        if (self.dataSouce.count != 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSouce.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
}

#pragma mark ================== noty =================
- (void)keyBoardShow:(NSNotification *)noti{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;

    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-height));
    }];
     [self.view layoutIfNeeded];
    [self scrollViewNextBottom];

}

- (void)keyboardHide:(NSNotification *)noti{
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(0));
    }];
    [self.view layoutIfNeeded];
}


#pragma mark ================== wode =================
- (void)clickSengMsg:(UIButton *)btn{
    [ChatModel requestSendMSGWithMsg:self.inputView.textField.text uid:self.uid superView:nil finshBlock:^(id obj, NSError *error) {
        ChatModel *chatModel = [[ChatModel alloc] init];
        chatModel.content = self.inputView.textField.text;
        chatModel.sface = [User LocalUser].face;
        chatModel.suid = [User LocalUser].uid;
        chatModel.dateline = [Utils stringWithDate:[NSDate date]];
        chatModel.snickname = [User LocalUser].nickname;
        chatModel.isRight = YES;
        [self.dataSouce addObject:chatModel];
        self.inputView.textField.text = nil;
        
        [self.tableView reloadData];
        [self scrollViewNextBottom];
    }];
}

-(void)scrollViewNextBottom{
    if (self.dataSouce.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSouce.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(CGRect)cellHeghtWithStr:(NSString*)str{
    CGRect rec = [str boundingRectWithSize:CGSizeMake(self.view.width-30-93, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    return rec;
}

#pragma mark ================== textfield delegate =================
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self clickSengMsg:nil];
    return YES;
}
#pragma mark ================== tableview delegate =================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModel *model = self.dataSouce[indexPath.row];
    CGRect rec =  [self cellHeghtWithStr:model.content];
    return rec.size.height + 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatModel * chat = self.dataSouce[indexPath.row];
    if (!chat.isRight && ![chat.suid isEqualToString:[User LocalUser].uid]){

        MessgeLeftTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:leftCell forIndexPath:indexPath];
        
        cell.chatModel = chat;
        return cell;
    }
    MessgeRightTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:rightCell forIndexPath:indexPath];
    cell.chatModel = chat;
    return cell;
}

#pragma mark ================== super =================
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
