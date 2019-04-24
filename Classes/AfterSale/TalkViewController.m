//
//  TalkViewController.m
//  Qqw
//
//  Created by xyg on 2017/1/7.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "TalkViewController.h"
#import "CommentCell.h"
#define MaxCount 9
#define Count 5  //一行最多放几张图片
#define ImageWidth ([UIScreen mainScreen].bounds.size.width-80)/Count
@interface TalkViewController (){
    OJLAnimationButton *sendBtn;
    UIView          *contentView;        //评论的背景视图
    MyTextView      *commentContent;
    UILabel         *tip;                //评论内容placeHoder
    UIView          *addImgView;         //评论图片View
    UIButton        *addImg;             //中间添加图片按钮
    UICollectionView *collection;        //存放图片的容器
    NSMutableArray  *imageArr;           //存放图片数据源
    UIActionSheet   *myActionSheet;
    BOOL cansend;
}

@property (nonatomic,strong)UpdownLoadMutibleImageApi *upLoadImage;
@property (nonatomic,strong)DistriButePictureApi *api;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *urlArray;
@property (nonatomic,strong)NSString *pictureUrlString;


@end

@implementation TalkViewController


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.imageArray removeAllObjects];
    self.title = @"发布评价";

}


- (UpdownLoadMutibleImageApi *)upLoadImage
{
    
    if (!_upLoadImage) {
        _upLoadImage = [[UpdownLoadMutibleImageApi alloc]init];
        _upLoadImage.delegate = self;
    }
    
    return _upLoadImage;
    
}

- (DistriButePictureApi *)api
{
    
    if (!_api) {
        _api = [[DistriButePictureApi alloc]init];
        _api.delegate = self;
    }
    return _api;
    
}

- (NSMutableArray *)imageArray
{
    
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)urlArray
{
    
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    cansend = NO;
    imageArr = [NSMutableArray array];
    
    [self initView]; //初始化视图
    //隐藏键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)];
    [self.view addGestureRecognizer:tap];
}


#pragma mark - 初始化视图
- (void)initView {
    
    commentContent = [[MyTextView alloc]initWithFrame:CGRectMake(7, 5, kScreenWidth- 20, 120) placeholderLab:@"说几句吧" labFont:14.0f maxLabNum:200 alertMge:@"文字字数超出限制" addSub:self.view];
    commentContent.tintColor = [UIColor colorWithRed:0.9059 green:0.502 blue:0.0863 alpha:1.0];
   
    addImgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(commentContent.frame)+10, kScreenWidth, ImageWidth+20)];
    addImgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addImgView];
    
    addImg = [UIButton buttonWithType:UIButtonTypeCustom];
    addImg.frame = CGRectMake(10, 10, ImageWidth, ImageWidth);
    [addImg setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    [addImg setBackgroundImage:[UIImage imageNamed:@"addImage_highlighted"] forState:UIControlStateSelected];
    [addImg addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [addImgView addSubview:addImg];
    
    //存放图片的UICollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addImg.frame)+10, 5, kScreenWidth-10-CGRectGetMaxX(addImg.frame), ImageWidth+10) collectionViewLayout:flowLayout];
    [collection registerClass:[CommentCell class] forCellWithReuseIdentifier:@"myCell"];
    [collection setAllowsMultipleSelection:YES];
    collection.showsHorizontalScrollIndicator = NO;
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor clearColor];
    [addImgView addSubview:collection];
    
    sendBtn = [OJLAnimationButton buttonWithFrame:CGRectMake(5, CGRectGetMaxY(addImgView.frame)+20, kScreenWidth-10, 40)];
    sendBtn.delegate = self;
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    sendBtn.backgroundColor = AppStyleColor;
    [self.view addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 发送监听
- (void)send {
    [self hiddenKeyboard]; //隐藏键盘
    
    NSString *content = [commentContent.text substringFromIndex:[self getTextBlankIndex]];
    if (content.length==0) {
        return;
    }
    
    [sendBtn startAnimation];
    
    for (int i = 0; i < imageArr.count; i++) {
        
        UIImage *image = [UIImage imageWithData:imageArr[i]];
        [self.imageArray addObject:image];
    }
    
    for (UIImage *image in self.imageArray) {
        
        [self.upLoadImage uploadImage:image];
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *pictureParameter = [self.urlArray componentsJoinedByString:@","];
                
        if ([commentContent.text isEqualToString:@""]) {
            
            [Utils postMessage:@"请输入评价内容" onView:self.view];
            return;
        }
        
        [self.api toDistributePicWithTid:self.cid content:commentContent.text picture:pictureParameter];
        
    });
    
}


#pragma  mark - 处理评价内容的空格
- (NSInteger)getTextBlankIndex{
    NSString *strUrl = commentContent.text;
    NSInteger index = strUrl.length;
    for (int i = 0 ; i < strUrl.length; i ++) { //处理评价内容的空
        NSString *str = [strUrl substringWithRange:NSMakeRange(i, 1)];
        if (![str isEqualToString:@" "]) {
            index = i;
            break;
        }
        
    }
    return index;
}

#pragma mark - 添加图片监听
- (void)addImage {
    if (imageArr.count>=MaxCount) {
        //[BHUD showErrorMessage:@"亲，最多只能上传9张图片哦~~"];
    } else {
        [self hiddenKeyboard]; //隐藏键盘
        myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从本地图库获取", nil];
        [myActionSheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0://打开照相机拍照
            [self takePhoto];
            break;
        case 1://打开本地相册
            [self LocalPhoto];
            break;
    }
}

#pragma mark - 打开照相机
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        ////NSLog(@"模拟器中无法使用照相机，请在真机中使用");
    }
}

#pragma mark - 打开本地图库
-(void)LocalPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = MaxCount-imageArr.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate【把选中的图片放到这里】
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type=[info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image=[info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        data=UIImageJPEGRepresentation(image, 0.5); //0.0最大压缩率  1.0最小压缩率
        //将获取到的图像image赋给UserImage，改变其头像
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage *originalImage = [UIImage imageWithData:data];
        UIImage *handleImage;
        handleImage = originalImage;
        
        if (imageArr.count<MaxCount) {
            [imageArr addObject:data];
        }
        
        if (imageArr.count<MaxCount) {
        } else {
            addImg.hidden = YES; //最多上传6张图片
        }
        if (imageArr.count*(ImageWidth+10)>kScreenWidth+20) {
            
        }
        [collection reloadData];
    }
    
}

#pragma mark - 照片选取取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            NSData *data;
            data=UIImageJPEGRepresentation(tempImg, 0.0); //0.0最大压缩率  1.0最小压缩率
            UIImage *originalImage = [UIImage imageWithData:data];
            UIImage *scaleImage = [self imageWithImageSimple:[UIImage imageWithData:data] scaledToSize:CGSizeMake(originalImage.size.width*0.5, originalImage.size.height*0.5)];
            
            UIImage *handleImage;
            double diagonalLength = hypot(scaleImage.size.width, scaleImage.size.height); //对角线
            if (diagonalLength>917) {
                double i = diagonalLength/917;
                handleImage = [self cutImage:scaleImage andSize:CGSizeMake(scaleImage.size.width/i, scaleImage.size.height/i)];
            } else {
                handleImage = scaleImage;
            }
            
            if (imageArr.count<MaxCount) {
                [imageArr addObject:data];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (imageArr.count<MaxCount) {
            } else {
                addImg.hidden = YES; //最多上传9张图片
            }
            
            [collection reloadData];
        });
    });
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.9451 green:0.5686 blue:0.1725 alpha:1.0]];
    //    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ImageWidth, ImageWidth);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"myCell";
    CommentCell *cell = (CommentCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageWithData:imageArr[indexPath.row]];
    cell.cancelBtn.tag = indexPath.row;
    [cell.cancelBtn addTarget:self action:@selector(cancelImg:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 取消选择的图片
- (void)cancelImg:(UIButton *)btn {
    CommentCell *cell = (CommentCell *)btn.superview;
    NSIndexPath *indexPath = [collection indexPathForCell:cell];
    [imageArr removeObjectAtIndex:indexPath.row];
    if (imageArr.count<MaxCount) {
        addImg.hidden = NO;
        //添加图片的按钮在第一行
        [collection reloadData];
    } else {
        addImg.hidden = YES; //最多上传6张图片
    }
    
}

//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

#pragma mark - UITextViewDelegate代理
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        tip.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (![text isEqualToString:@""]) {
        tip.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        tip.hidden = NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - 隐藏键盘
- (void)hiddenKeyboard {
    [self.view endEditing:YES]; //结束编辑设置
}

#pragma mark - 压缩、裁剪图片
- (UIImage *)cutImage:(UIImage*)image andSize:(CGSize)size
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (size.width / size.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * size.height / size.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * size.width / size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    
    return [UIImage imageWithCGImage:imageRef];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    if (api == _upLoadImage) {
        
        [self.urlArray addObject:responsObject];
        
    }
    
    if (api == _api) {
        
        [sendBtn stopAnimation];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refresh" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    NSLog(@"%@",responsObject);
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
}

#pragma mark OJLAnimationButtonDelegate
-(void)OJLAnimationButtonDidStartAnimation:(OJLAnimationButton *)OJLAnimationButton{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [OJLAnimationButton stopAnimation];
    });
    
}

-(void)OJLAnimationButtonDidFinishAnimation:(OJLAnimationButton *)OJLAnimationButton{
    NSLog(@"stop");
}

-(void)OJLAnimationButtonWillFinishAnimation:(OJLAnimationButton *)OJLAnimationButton{
    if (OJLAnimationButton == sendBtn) {
        
    }
}



@end
