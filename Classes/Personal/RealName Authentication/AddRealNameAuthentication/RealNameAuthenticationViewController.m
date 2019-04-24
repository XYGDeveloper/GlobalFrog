//
//  RealNameAuthenticationViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2017/1/5.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "RealNameAuthenticationViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "realNameAuthApi.h"
#import "Uploader.h"
@interface RealNameAuthenticationViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ApiRequestDelegate>
//name
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//ID
@property (weak, nonatomic) IBOutlet UITextField *identityTextField;
@property (weak, nonatomic) IBOutlet UIImageView *identityFirstSide;
@property (weak, nonatomic) IBOutlet UIImageView *identityTheOtherSide;
@property (weak, nonatomic) IBOutlet UILabel *upDownIdentitySide;
@property (weak, nonatomic) IBOutlet UILabel *upDownIdentityTheOtherSide;

@property (nonatomic,strong)realNameAuthApi *realNameApi;
@property (nonatomic,strong)MBProgressHUD *hub;
@property (nonatomic,strong)NSString *faceString;
@property (nonatomic,strong)NSString *backString;

@property (nonatomic,strong)UIImagePickerController *sidePicker;
@property (nonatomic,strong)UIImagePickerController *otherSidePicker;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (nonatomic,strong) UIActionSheet *backActionSheet;

@end

@implementation RealNameAuthenticationViewController

- (realNameAuthApi *)realNameApi
{

    if (!_realNameApi) {
        _realNameApi = [[realNameAuthApi alloc]init];
        _realNameApi.delegate = self;
    }
    
    return _realNameApi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightNavigationItemWithTitle:@"保存" action:@selector(SaveAction:)];

    self.identityFirstSide.image = [UIImage imageNamed:@"identityDefaultImage"];
    self.identityFirstSide.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *firstSide = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upDownIdentityFirstSideAction:)];
    [self.identityFirstSide addGestureRecognizer:firstSide];

     self.identityTheOtherSide.image = [UIImage imageNamed:@"identityDefaultImage"];
    self.identityTheOtherSide.userInteractionEnabled = YES;
    UITapGestureRecognizer *theOtherSide = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upDownIdentityTheOtherSide:)];
    [self.identityTheOtherSide addGestureRecognizer:theOtherSide];
    
    self.nameTextField.delegate = self;
    self.nameTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.identityTextField.delegate = self;
    self.identityTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.identityTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.identityTextField.secureTextEntry = YES;
    
    // Do any additional setup after loading the view from its nib.
}


- (void)SaveAction:(UIBarButtonItem *)saveBar
{
    
    if ([self.nameTextField.text isEqualToString:@""]) {
        
        [Utils postMessage:@"请输入姓名" onView:self.view];
        return;
    }
    
    if ([self.identityTextField.text isEqualToString:@""]) {
        
        [Utils postMessage:@"请输入您的身份证号" onView:self.view];
        return;
    }
    
    [self.realNameApi upRealNameAuthInfoWithName:self.nameTextField.text isDefault:@"0" number:self.identityTextField.text face:_faceString back:_backString];
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//上传身份证正面和反面

- (IBAction)upDownIdentityFirstSideAction:(id)sender {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择身份证正面" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册",@"删除", nil];
    }else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择身份证正面" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"相册",@"删除", nil];
    }
    
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet == _actionSheet) {
        NSUInteger sourceType;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    self.sidePicker = [[UIImagePickerController alloc] init];
                    _sidePicker.delegate = self;
                    _sidePicker.allowsEditing = YES;
                    self.sidePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    //录制视频时长，默认10s
                    self.sidePicker.videoMaximumDuration = 15;
                    //视频上传质量
                    //UIImagePickerControllerQualityTypeHigh高清
                    //UIImagePickerControllerQualityTypeMedium中等质量
                    //UIImagePickerControllerQualityTypeLow低质量
                    //UIImagePickerControllerQualityType640x480
                    //设置摄像头模式（拍照，录制视频）为录像模式
                    self.sidePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                    [self presentViewController:_sidePicker animated:YES completion:nil];
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    // 跳转到相机或相册页面
                    self.sidePicker = [[UIImagePickerController alloc] init];
                    _sidePicker.delegate = self;
                    _sidePicker.allowsEditing = YES;
                    _sidePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:_sidePicker animated:YES completion:^{
                        
                    }];
                    break;
                case 2:
                    //来源:相册
                    self.addSide.hidden = NO;
                    self.upLoadLabel.hidden = NO;
                    self.identityFirstSide.image = [UIImage imageNamed:@"identityDefaultImage"];
                    
            }
        }
        else {
            if (buttonIndex == 2) {
                //来源:相册
                self.addSide.hidden = NO;
                self.upLoadLabel.hidden = NO;
                self.identityFirstSide.image = [UIImage imageNamed:@"identityDefaultImage"];
                
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
      

    }
    
    if (actionSheet == _backActionSheet) {
        NSUInteger sourceType;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机                    //来源:相机
                    self.otherSidePicker = [[UIImagePickerController alloc] init];
                    self.otherSidePicker.delegate = self;
                    self.otherSidePicker.allowsEditing = YES;
                    self.otherSidePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    //录制视频时长，默认10s
                    self.otherSidePicker.videoMaximumDuration = 15;
                    //视频上传质量
                    //UIImagePickerControllerQualityTypeHigh高清
                    //UIImagePickerControllerQualityTypeMedium中等质量
                    //UIImagePickerControllerQualityTypeLow低质量
                    //UIImagePickerControllerQualityType640x480
                    //设置摄像头模式（拍照，录制视频）为录像模式
                    self.otherSidePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                    [self presentViewController:_otherSidePicker animated:YES completion:nil];
                    break;
                case 1:
                    //来源:相册
                    // 跳转到相机或相册页面
                    self.otherSidePicker = [[UIImagePickerController alloc] init];
                    _otherSidePicker.delegate = self;
                    _otherSidePicker.allowsEditing = YES;
                    _otherSidePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    [self presentViewController:_otherSidePicker animated:YES completion:^{
                        
                    }];
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    
                    self.addOtherSide.hidden = NO;
                    self.upDownIdentityTheOtherSide.hidden = NO;
                    self.identityTheOtherSide.image = [UIImage imageNamed:@"identityDefaultImage"];
                    
                    break;
            }
        }
        else {
            if (buttonIndex == 2) {
                self.addOtherSide.hidden = NO;
                self.upDownIdentityTheOtherSide.hidden = NO;
                self.identityTheOtherSide.image = [UIImage imageNamed:@"identityDefaultImage"];
                
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
    }
    
}


- (IBAction)upDownIdentityTheOtherSide:(id)sender {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.backActionSheet = [[UIActionSheet alloc] initWithTitle:@"选择身份证反面" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册",@"删除", nil];
    }else{
        self.backActionSheet = [[UIActionSheet alloc] initWithTitle:@"选择身份证反面" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"相册",@"删除", nil];
    }
    
    self.backActionSheet.tag = 1001;
    [self.backActionSheet showInView:self.view];
    
}

#pragma mark-UIImagepickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    
    if (picker == _sidePicker) {
    
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            //关闭相册界面
            [picker dismissViewControllerAnimated:YES completion:^{
                
                [[Uploader sharedUploader] upLoadImage:image parameter:@{@"name": self.nameTextField.text ?: @"", @"is_default": @"0",@"number": self.identityTextField.text ?: @"",} withCompletionBlock:^(ApiCommand *cmd, BOOL success, NSString *imageUrl) {
                    
                    [self.identityFirstSide sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_small"]];
                    self.addSide.hidden = YES;
                    self.upLoadLabel.hidden = YES;
                    self.faceString = imageUrl;
                    
                }];
            }];
        
    }
    
    if (picker == _otherSidePicker) {
    
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            //关闭相册界面
            [picker dismissViewControllerAnimated:YES completion:^{
                
                [[Uploader sharedUploader] upLoadImage:image parameter:@{@"name": self.nameTextField.text ?: @"", @"is_default": @"0",@"number": self.identityTextField.text ?: @"",} withCompletionBlock:^(ApiCommand *cmd, BOOL success, NSString *imageUrl) {
                    
                    [self.identityTheOtherSide sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_small"]];
                    self.addOtherSide.hidden = YES;
                    self.upDownIdentityTheOtherSide.hidden = YES;
                    self.backString = imageUrl;
                    
                }];
            }];
        }
   
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    [Utils postMessage:command.response.msg onView:self.view];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    [Utils postMessage:command.response.msg onView:self.view];

}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
