//
//  UseViewController.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "UseViewController.h"
#import "UseTableViewCell.h"
@interface UseViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UITableView *tableView;


@end

@implementation UseViewController

static NSString* use = @"useCell";

- (void)initViewController
{

    _textField = [[UITextField alloc]init];
    [self.view addSubview:_textField];
    _textField.layer.borderColor = [UIColor grayColor].CGColor;
    _textField.layer.borderWidth = 1;
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(2);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(-100);
        make.height.mas_equalTo(35);
      
    }];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:_button];
    
    [_button setTitle:@"兑换" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setBackgroundColor:[UIColor grayColor]];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(2);
        make.left.mas_equalTo(_textField.mas_right).mas_equalTo(10);
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(-5);
        make.height.mas_equalTo(35);
        
    }];
    
    self.tableView = [[UITableView alloc]init];
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_textField.mas_bottom).mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UseTableViewCell class] forCellReuseIdentifier:use];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    
    [self.view endEditing:YES];
    

}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
 
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 10;


}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:use];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 110;

}







- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewController];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
