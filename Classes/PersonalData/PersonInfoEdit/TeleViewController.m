//
//  TeleViewController.m
//  Qqw
//
//  Created by XYG on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "TeleViewController.h"

@interface TeleViewController ()
@property(nonatomic,copy)textFiledResultBlock result;
@property(nonatomic,strong)NSString* customTitle;
@property(nonatomic,strong)UITextField* myTextFiled;
@property(nonatomic,strong)NSString* content;
@end

@implementation TeleViewController

-(id)initWithTitle:(NSString*)title textContent:(NSString*)content TextFiledResult:(textFiledResultBlock)result
{
    if (self=[super init]) {
        
        self.customTitle = title;
        
        self.result = result;
        
        self.content = content;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)initView
{
    self.title = self.customTitle;
    self.view.backgroundColor = RGB(238.0f,238.0f,243.0f);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.myTextFiled = [[UITextField alloc] init];
    self.myTextFiled.text = self.content;
    
    self.myTextFiled.textColor = HexColorA(0x323232,0.8);
    self.myTextFiled.font = [UIFont systemFontOfSize:15.0f];
    self.myTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.myTextFiled.backgroundColor = [UIColor whiteColor];
    self.myTextFiled.leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0,10.0f,50.0f)];
    self.myTextFiled.leftViewMode =UITextFieldViewModeAlways;
    [self.myTextFiled becomeFirstResponder];
    [self.view addSubview:self.myTextFiled];
    [self.myTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(50.0f);
    }];
    
    
    
    [self setRightNavigationItemWithTitle:@"保存" action:@selector(saveAction)];
    

}






-(void)saveAction
{
    
    
    NSUserDefaults *usersss = [NSUserDefaults standardUserDefaults];
    [usersss setObject:self.myTextFiled.text forKey:@"nike"];
    [usersss synchronize];
    
    NSLog(@"%@", [usersss objectForKey:@"nike"]);
    
    if (self.result) {
        
        self.result(self.myTextFiled.text);
        
        [self.navigationController popViewControllerAnimated:YES];
   
        
    }
}


-(void)dealloc
{
    NSLog(@"%@销毁了",NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
