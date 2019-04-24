//
//  QqwPersonalDataEditController.m
//  Qqw
//
//  Created by elink on 16/7/26.
//  Copyright © 2016年 gao.jian. All rights reserved.
//
#import "QqwPersonalDataEditController.h"
#import "QqwTextFiledController.h"
#import "QqwPersonalDataCell.h"
#import "QqwSexRadioCell.h"
#import "TelephoneCell.h"
#import "TeleViewController.h"
#import <MBProgressHUD.h>
#import "ValidatorUtil.h"
#import "QqwAddressPickerView.h"
#import "User.h"
#import "LoginViewControll.h"
#import "Uploader.h"
#import "BindCdellTableViewCell.h"
#import "TelephoneVarViewController.h"
#import <UMSocial.h>

@interface QqwPersonalDataEditController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)QqwAddressPickerView*picker;
@property(nonatomic,strong)UITableView* myTableView;
@property(nonatomic,strong)UILabel *WXLabel;
@property(nonatomic,assign)NSInteger sex;
@property(nonatomic,strong)NSString* telephone;
@property(nonatomic,strong)NSString* nickName;
@property(nonatomic,strong)NSString* address;
@property(nonatomic,strong)UIImageView *head;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *imagUrl;
@property(nonatomic,strong)NSString *isBindState;
@property(nonatomic,assign)BOOL state;
@property(nonatomic,strong)UILabel *descriptionTitle;


@property(nonatomic,strong)User *userInfo;

@property(nonatomic,strong)MBProgressHUD *hub;

@end

@implementation QqwPersonalDataEditController
static NSString* cellID = @"QqwPersonalDataEditCell";
static NSString* sexCellID = @"QqwSexRadioCell";
static NSString* teleCellID = @"QqwteleCell";
static NSString* bindCellID = @"bindCell";

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [User requestUserInfoWithuperView:self.view finshBlock:^(User *obj, NSError *error) {
        self.nickName = [User LocalUser].nickname;
        self.telephone = [User LocalUser].mobile;
        self.sex = [[User LocalUser].sex intValue];
        
        if (obj.province&&obj.city&&obj.district) {
            self.address = [NSString stringWithFormat:@"%@ %@ %@",obj.province,obj.city,obj.district];
        }else{
            self.address = @"省--市--区";
        }
        [User setLocalUser:[User LocalUser]];
        
        [self.myTableView reloadData];
        
    }];
    [self initView];
    
    [self setRightNavigationItemWithTitle:@"保存" action:@selector(SaveAction:)];
}

-(void)initView{
    self.title = @"修改个人资料";
    self.view.backgroundColor = [UIColor colorWithWhite:0.965 alpha:1.000];
    self.myTableView = ({
        
        UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[QqwPersonalDataCell class] forCellReuseIdentifier:cellID];
        [tableView registerClass:[QqwSexRadioCell class] forCellReuseIdentifier:sexCellID];
        [tableView registerClass:[TelephoneCell class] forCellReuseIdentifier:teleCellID];
        [tableView registerNib:[UINib nibWithNibName:@"BindCdellTableViewCell" bundle:nil] forCellReuseIdentifier:bindCellID];
        
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        tableView;
    });
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
      
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        bgView.backgroundColor = [UIColor whiteColor];
        self.head = ({
            
            UIImageView* image = [UIImageView new];
            
            image.contentMode = UIViewContentModeScaleToFill;
            
            image.userInteractionEnabled = YES;
            
            [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTouchAction)]];
            
            image.image = [UIImage imageNamed:@"headView"];
            image.layer.masksToBounds = YES;
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.layer.borderWidth = 1.0f;
            image.layer.borderColor = [UIColor colorWithWhite:0.996 alpha:1.000].CGColor;
            
            image.layer.cornerRadius = 35.0f;
            
            [bgView addSubview:image];
            
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.with.height.mas_equalTo(70);
                make.left.mas_equalTo(bgView.mas_left).mas_equalTo(20);
                make.top.mas_equalTo(20);
            }];
            
            image;
        });
    
        [self.head sd_setImageWithURL:[NSURL URLWithString:[User LocalUser].face] placeholderImage:[UIImage imageNamed:@"placeholder_small"]];
        
        self.label = ({
            
            UILabel* lab = [UILabel new];
            lab.textColor = [UIColor colorWithWhite:0.069 alpha:1.000];
            lab.userInteractionEnabled = YES;
            lab.textAlignment = NSTextAlignmentLeft;
            
            lab.font = [UIFont systemFontOfSize:16];
            lab.textColor = HexColorA(0x323232,0.8);
            lab.text = self.nickName;
            [bgView addSubview:lab];
            
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_head.mas_right).mas_equalTo(5);
                make.centerY.mas_equalTo(_head.centerY);
                make.height.mas_equalTo(30);
                make.width.mas_equalTo(150);
            }];
            
            lab;
            
        });
        
        self.descriptionTitle = ({
            
            UILabel* lab = [UILabel new];
            lab.textColor = [UIColor colorWithWhite:0.069 alpha:1.000];
            lab.userInteractionEnabled = YES;
            lab.textAlignment = NSTextAlignmentLeft;
            
            lab.font = [UIFont systemFontOfSize:16];
            lab.text = @"点击头像可编辑";
            lab.textColor =HexColorA(0x323232,0.5);
            lab.textColor = [UIColor colorWithWhite:0.720 alpha:1.000];
            lab.font =[UIFont systemFontOfSize:13.0f];
            
            [bgView addSubview:lab];
            
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_head.mas_right).mas_equalTo(5);
                make.top.mas_equalTo(_label.mas_bottom).mas_equalTo(0);
                make.height.mas_equalTo(30);
                make.width.mas_equalTo(150);
            }];
            
            lab;
            
        });
        
        
        return bgView;
        
    }else
    {
    
        UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5,0, kScreenWidth, 30)];
        label.text = @"第三方绑定";
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor =[UIColor colorWithWhite:0.720 alpha:1.000];

        [customView addSubview:label];
        
        return customView;
        
        
    }
    
}


- (void)headTouchAction{
    //选择方式
    if ([[UIDevice currentDevice].systemVersion floatValue] >=8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        UIAlertAction *actionCaream = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self changeHeadIconWithCamera];
        }];
        UIAlertAction *actionBlum = [UIAlertAction actionWithTitle:@"从相册中选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self changeHeadIconWithBlum];
        }];
        
        [alertController addAction:action];
        [alertController addAction:actionBlum];
        [alertController addAction:actionCaream];
        
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    else{
        
        UIActionSheet *actionSheet = [UIActionSheet actionSheetWithTitle:@"取消" cancelButtonTitle:@"从相册中选择" destructiveButtonTitle:@"拍照" otherButtonTitles:nil dismissBlock:^(UIActionSheet *zg_actionSheet, NSInteger buttonIndex) {
            
            if (buttonIndex == 0) {
                
            }else if (buttonIndex == 1){
                [self changeHeadIconWithBlum];
                
                
            }else
            {
                
                [self changeHeadIconWithCamera];
                
            }
            
        }];
        [actionSheet showInView:self.view];
    }
}


- (void)changeHeadIconWithCamera{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        __block UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        ipc.navigationBar.barTintColor =[UIColor whiteColor];
        ipc.navigationBar.tintColor = [UIColor whiteColor];
        ipc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        [self presentViewController:ipc animated:YES completion:^{
            ipc = nil;
        }];
    } else {
        NSLog(@"模拟器无法打开照相机");
    }
}


- (void)changeHeadIconWithBlum
{
    __block UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    picker.navigationBar.barTintColor =[UIColor whiteColor];
    picker.navigationBar.tintColor = [UIColor blackColor];
    picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [self presentViewController:picker animated:YES completion:^{
        picker = nil;
    }];
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //完成选择
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    if ([type isEqualToString:@"public.image"]) {
        
        _hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        _hub.mode = MBProgressHUDAnimationFade;
        
        //转换成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [picker dismissViewControllerAnimated:YES completion:^{

            [[Uploader sharedUploader] uploadImage:image withCompletionBlock:^(ApiCommand *cmd, BOOL success, NSString *imageUrl) {
                _hub.removeFromSuperViewOnHide = YES;
                // 1秒之后再消失
                [_hub hideAnimated:YES afterDelay:0.8];
                [Utils removeAllHudFromView:self.view];
                [Utils postMessage:cmd.response.msg onView:self.view];
                NSLog(@"%@",imageUrl);
                self.imagUrl = imageUrl;
                [User LocalUser].face = _imagUrl;
                [User saveToDisk];
                [self.head sd_setImageWithURL:[NSURL URLWithString:_imagUrl] placeholderImage:[UIImage imageNamed:@"placeholder_small"]];

            }];
        }];
        
    }
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
    

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return 110;
        
    }else
    {

        return 30;
        
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return 4;
        
    }else
    {
    
        return 1;
    }
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    if (indexPath.section == 0) {
        
        
        if (indexPath.row==2) {
            
            QqwSexRadioCell* cell = [tableView dequeueReusableCellWithIdentifier:sexCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             cell.textLabel.textColor =HexColorA(0x323232,0.8);
            [cell setSexSelected:male withSelectResult:^(sex sex) {
                
                self.sex = sex;
                [User LocalUser].sex = [NSString stringWithFormat:@"%ld",(unsigned long)sex];
                [User saveToDisk];
                
                NSLog(@"性别：%ld",(unsigned long)sex);
                
            }];

            return cell;
            
        }else
        {
            
            QqwPersonalDataCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             cell.textLabel.textColor =HexColorA(0x323232,0.8);
            if (indexPath.row==0) {
                
                cell.accessoryType = UITableViewCellAccessoryNone;

                [cell setTitle:@"手机" withContent:self.telephone];
                
            }else if (indexPath.row==1)
            {
                [cell setTitle:@"昵称" withContent:self.nickName];
            }else
            {
                
                [cell setTitle:@"地区" withContent:self.address];
                
            }

            return cell;
            
        }

    }else {

        BindCdellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bindCellID];
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         cell.textLabel.textColor =HexColorA(0x323232,0.8);
        
        if (indexPath.section == 1 && indexPath.row == 0) {
          
            if ([User LocalUser].isweixin == YES) {
                cell.bindName.text = @"微信";
                cell.isBind.text = @"已绑定";
            }else
            {
                cell.isBind.text = @"未绑定";
            }
        }
        return cell;
    }
}


#pragma mark - TableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        
        __block QqwPersonalDataEditController* this = self;
        
        if(indexPath.row==0)
        {
            
            TeleViewController* tele = nil;
            tele = [[TeleViewController alloc] initWithTitle:@"手机修改" textContent:self.telephone TextFiledResult:^(NSString *text) {
                
                self.telephone = text;
                [User LocalUser].mobile = _telephone;
                [User saveToDisk];
                [this.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
          //  [self.navigationController pushViewController:tele animated:YES];
        }
        else if(indexPath.row==1)
        {
            
            QqwTextFiledController* nike = [[QqwTextFiledController alloc] initWithTitle:@"昵称修改" textContent:self.nickName TextFiledResult:^(NSString *text)
            {
                
                self.nickName = text;
                self.label.text = text;
                
                [User LocalUser].nickname = _nickName;
                [User saveToDisk];
                
                [this.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            [self.navigationController pushViewController:nike animated:YES];
            
        }else if (indexPath.row==3)
        {
            self.picker= [QqwAddressPickerView showAddressPickerViewOn:self.view SelectedResult:^(NSString *result)
                          {
                              
                              NSLog(@"%@",result);
                              NSMutableArray *arr = [result componentsSeparatedByString:@" "].mutableCopy;
                              
                              NSString *province = [arr objectAtIndex:0];
                              NSString *city = [arr objectAtIndex:1];
                              NSString *areas = [arr objectAtIndex:2];
                              
                              [User LocalUser].province = province;
                              [User LocalUser].city = city;
                              [User LocalUser].district = areas;
                              [User saveToDisk];
                              
                              if ([[User LocalUser].province isEqualToString:@""]&&[[User LocalUser].city isEqualToString:@""]&&[[User LocalUser].district isEqualToString:@""])
                              {
                                  
                                   self.address = [NSString stringWithFormat:@"%@ %@ %@",[User LocalUser].province,[User LocalUser].city,[User LocalUser].district];
                                  
                              }else
                              {
                              
                              self.address = [NSString stringWithFormat:@"%@ %@ %@",province,city,areas];
                              
                              NSLog(@"%@",_address);
                                  
                              }
                              
                              [this.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                              
                          }];
            
            [self.picker show];

        }
        
    }else{
        if ([Utils showLoginPageIfNeeded]){
            
            
        } else{

            if ([User LocalUser].isweixin == YES){
                return;
            }else{
            //绑定手机页面
            
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                {
                
                if (response.responseCode == UMSResponseCodeSuccess)
                {
                    
                    NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
                    UMSocialAccountEntity *snsAccount = [dict valueForKey:snsPlatform.platformName];
                    NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
                    NSString *openid =snsAccount.unionId;
                    NSLog(@"openid:%@",openid);
                    
                    [User requestBindWithOpenID:openid type:@"appWechat" sperView:self.view finshBlock:^(id obj, NSError *error) {
                        if (!error) {
                            [User LocalUser].isweixin = YES;
                            [User saveToDisk];
                            NSLog(@"后出现：%d",[User LocalUser].isweixin);
                            [self.myTableView reloadData];
                            [Utils postMessage:@"绑定成功" onView:self.view];
                        }
                    }];
             
                }
                
            });
                
            }
            
            
        }
        
        
    }
    
    
    [self.myTableView reloadData];
  
    
}

-(void)toast:(NSString *)title{
    [Utils showErrorMsg:self.view type:0 msg:title];
}

-(void)toastWithError:(NSError *)error{
    NSString *errorStr = [NSString stringWithFormat:@"网络出错：%@，code：%ld", error.domain, (long)error.code];
    [self toast:errorStr];

}

- (void)SaveAction:(UIBarButtonItem *)save{

    if ([self.nickName isEqualToString:@""]) {
        
        [self toast:@"请输入昵称"];
        return;
        
    }
    
    if ([[NSString stringWithFormat:@"%ld",(long)self.sex]isEqualToString:@""]) {
        
        [self toast:@"请选择性别"];
        return;
        
    }
    
    if ([self.address isEqualToString:@""]) {
        
        [self toast:@"请选择地址"];
        return;
    }
  
    NSArray *addressArr = [self.address componentsSeparatedByString:@" "];
    
    NSString *province;
    NSString *city;
    NSString *distrction;
    if (addressArr) {
        province = [addressArr safeObjectAtIndex:0];
        city = [addressArr safeObjectAtIndex:1];
        distrction = [addressArr safeObjectAtIndex:2];
    }else{
       self.address = @"省--市--区";
    }

     NSLog(@"%@,%@,%@,%@,%@,%@",self.telephone,self.nickName,province,city,distrction,[NSString stringWithFormat:@"%ld",(long)self.sex]);

    User * u = [User new];
    u.nickname = self.nickName;
    u.sex = [NSString stringWithFormat:@"%ld",(long)self.sex] ;
    u.face = _imagUrl;
    u.province = province;
    u.city = city;
    u.district = distrction;
    
    
    [UserRequestApi requestSaveUserInfoWithUserInfo:u superView:self.view finshBlock:^(User * currentUser, NSError *error) {
        [User LocalUser].uid = currentUser.uid;
        [User LocalUser].nickname = currentUser.nickname;
        [User LocalUser].isweixin = currentUser.isweixin;
        [User LocalUser].ismobile = currentUser.ismobile;
        [User LocalUser].ismember = currentUser.ismember;
        [User LocalUser].face = currentUser.face;
        [User LocalUser].sex = currentUser.sex;
        [User LocalUser].butler_name = currentUser.butler_name;
        [User LocalUser].butler_mobile = currentUser.butler_mobile;
        [User LocalUser].role = currentUser.role;
        [User LocalUser].province = currentUser.province;
        [User LocalUser].city = currentUser.city;
        [User LocalUser].district = currentUser.district;

        [User saveToDisk];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
