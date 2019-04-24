//
//  SetPageViewController.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/10.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "SetPageViewController.h"
#import "ClearCacheTableViewCell.h"
#import "ServiceBackViewController.h"
#import "QqwAboutViewController.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#define cellIdentity @"cell"
#define cleanIdentity @"cleanCell"

@interface SetPageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign)NSString *Appid ; //版本号
@property (nonatomic,assign)NSInteger fileCount;  //缓存文件大小
@property(nonatomic,strong)UITableView *tableView;


@end


@implementation SetPageViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithController];

    // Do any additional setup after loading the view from its nib.
}

- (void)initWithController
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentity];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClearCacheTableViewCell" bundle:nil] forCellReuseIdentifier:cleanIdentity];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        
    }];
    
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 6;

}


- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 1) {
        return 1;
    }else if (section == 2)
    {
        return 1;
    }else if (section == 3)
    {
        return 1;
    }else if (section == 4)
    {
        return 1;
    }else if (section == 5)
    {
        return 1;
    }else
    {
        return 1;
    }
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"修改密码";
        
    }else if (indexPath.section == 1 && indexPath.row == 0)
    {
     cell.textLabel.text = @"检查新版本";
    
    }else if (indexPath.section == 2 && indexPath.row == 0)
    {

        ClearCacheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cleanIdentity];
        cell.clearCount.text =[NSString stringWithFormat:@"%ldM",_fileCount];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
        
    }else if (indexPath.section == 3 && indexPath.row == 0)
    {
        cell.textLabel.text = @"关于全球蛙";
        
    }else if (indexPath.section == 4 && indexPath.row == 0)
    {
        cell.textLabel.text = @"服务与反馈";
        
    }else if (indexPath.section == 5 && indexPath.row == 0)
    {
        cell.textLabel.text = @"退出登录";
        
    }
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
//        FindViewController *find = [[FindViewController alloc]init];
//
//        [self.navigationController pushViewController:find animated:YES];

        
    }else if (indexPath.section == 1 && indexPath.row == 0)
    {
        
        [self checkVersionNumber];
        
        
    }else if (indexPath.section == 2 && indexPath.row == 0)
    {
        
        [self cleanSystemCache];
        
        
    }else if (indexPath.section == 3 && indexPath.row == 0)
    {
        [self AboutQuanQiuWa];
        
    }else if (indexPath.section == 4 && indexPath.row == 0)
    {
       [self serviseAndConmment];
        
    }else if (indexPath.section == 5 && indexPath.row == 0)
    {
        
        [self exitUserLogin];
        

    }


}


#pragma mark - 返回到上一页...................

- (void)backAction:(UIBarButtonItem *)backButton
{

    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 修改密码......................

- (void)modifyUserPwd
{




}

#pragma mark - 退出登录.......................

- (void)exitUserLogin
{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:USER_LOGIN_out parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
       
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.description);
        
    }];


    
    

}

#pragma mark- 关于全球蛙.......................

- (void)AboutQuanQiuWa
{
    QqwAboutViewController *about = [[QqwAboutViewController alloc]init];
    [self.navigationController pushViewController:about animated:YES];

}

#pragma mark - 服务与反馈.....................

- (void)serviseAndConmment
{
    ServiceBackViewController *feed =[[ServiceBackViewController alloc]init];
    [self.navigationController pushViewController:feed animated:YES];
    
}

#pragma mark -清除缓存...........................
//清除缓存

- (void)cleanSystemCache
{
    
    
    //开辟线程，清除缓存..........
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%ld",[files count]);
                       
                       _fileCount =files.count;
                       
                       for (NSString *p in files)
                       {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                           {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       
                       
                     
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                   }
                   );
    
    
   

}

//清除缓存成功回调

-(void)clearCacheSuccess
{
    
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"成功清除了%ldM的缓存",_fileCount] preferredStyle:UIAlertControllerStyleAlert];
    
            UIAlertAction *actionDo = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    
            }];
            [alertController addAction:actionDo];
            [self presentViewController:alertController animated:YES completion:nil];
    
   
    
}



#pragma mark- 版本更新..................................
//检查新版本

- (void)checkVersionNumber
{
    
    /**
     *  加载菊花
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 再设置模式
    hud.mode = MBProgressHUDModeIndeterminate;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    
    NSString *client_ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString *ver_number = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *currentVersion = [NSString stringWithFormat:@"%@.%@",client_ver,ver_number];
    NSLog(@"当前版本号：%@",currentVersion);
  
//客户端请求版本更新
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:SET_VERSION_UPDATA parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSArray *applicationInfo = [responseObject objectForKey:@"results"];
        NSLog(@"vvvvvv%@",applicationInfo);
        NSDictionary *dic = [applicationInfo lastObject];
        NSLog(@"tttttt%@",dic);
        NSString *lastVersion = [dic objectForKey:@"version"];
       
                if (![lastVersion isEqualToString:currentVersion]) {
                    //trackViewURL = [releaseInfo objectForKey:@"trackVireUrl"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新" message:[NSString stringWithFormat:@"发现新的版本(%@),前去更新",lastVersion] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                    alert.tag = 10000;
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新" message:[NSString stringWithFormat:@"此版本为最新版本版本(%@)",lastVersion] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag = 10001;
                    [alert show];
                }
        
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        // 1秒之后再消失
        [hud hide:YES afterDelay:0.5];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        
    }];
    
}

//跳转到苹果官网前去下载
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:SET_DOWN_LEASTVERSION];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}


- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}


@end
