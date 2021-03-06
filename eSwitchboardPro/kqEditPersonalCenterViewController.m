//
//  kqEditPersonalCenterViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/9/25.
//  Copyright © 2015年 海峰. All rights reserved.
//
#define ORIGINAL_MAX_WIDTH 640.0f
#import "kqEditPersonalCenterViewController.h"
#import "AppDelegate.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface kqEditPersonalCenterViewController ()<VPImageCropperDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,kqDownloadManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *superView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) UIImage *headerImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *postionTextField;
@property (strong, nonatomic) NSString *staNameString,*staNickNameString,*staCompanyString,*staPositionString;

@end

@implementation kqEditPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopBar];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    if ([[pinfo.userInfomation valueForKey:@"usericon"] isKindOfClass:[NSNull class]]) {
        [self.headerImageView setImage:[UIImage imageNamed:@"zhanghuxinxi"]];
    }else{
        NSString *urlString = [NSString stringWithFormat:@"%@",[pinfo.userInfomation valueForKey:@"usericon"]];
//        [self.headerImageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"zhanghuxinxi"]];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"zhanghuxinxi"]];
    }
    if (!([[pinfo.userInfomation valueForKey:@"username"] isKindOfClass:[NSNull class]])) {
        self.nameTextField.text = [pinfo.userInfomation valueForKey:@"username"];
        self.staNameString = [pinfo.userInfomation valueForKey:@"username"];
    }else{
        self.nameTextField.text = @"";
        self.staNameString = @"";
    }
    if (!([[pinfo.userInfomation valueForKey:@"company"] isKindOfClass:[NSNull class]])) {
        self.companyTextField.text = [pinfo.userInfomation valueForKey:@"company"];
        self.staCompanyString = [pinfo.userInfomation valueForKey:@"company"];
    }else{
        self.companyTextField.text = @"";
        self.staCompanyString = @"";
    }
    if (!([[pinfo.userInfomation valueForKey:@"userposition"] isKindOfClass:[NSNull class]])) {
        self.postionTextField.text = [pinfo.userInfomation valueForKey:@"userposition"];
        self.staPositionString = [pinfo.userInfomation valueForKey:@"userposition"];
    }else{
        self.postionTextField.text = @"";
        self.staPositionString = @"";
    }
    if (!([[pinfo.userInfomation valueForKey:@"nickname"] isKindOfClass:[NSNull class]])) {
        self.nickNameTextField.text = [pinfo.userInfomation valueForKey:@"nickname"];
        self.staNickNameString = [pinfo.userInfomation valueForKey:@"nickname"];
    }else{
        self.nickNameTextField.text = @"";
        self.staNickNameString = @"";
    }
    // Do any additional setup after loading the view from its nib.
}

#pragma keyBoardNotification
-(void) keyboardWillShow:(NSNotification *)note
{
    if (self.nameTextField.isFirstResponder || self.nickNameTextField.isFirstResponder) {
        return;
    }
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    UIScreen *ms = [UIScreen mainScreen];
    if (ms.bounds.size.height - keyboardBounds.size.height >= 300 + 64) {
        return;
    }else{
        if ((ms.bounds.size.height - keyboardBounds.size.height >= 250 + 64) && self.companyTextField.isFirstResponder) {
            return;
        }
    }
    CGFloat height;
    if (self.companyTextField.isFirstResponder) {
        height = 250 + 64 - (ms.bounds.size.height - keyboardBounds.size.height);
    }else{
        height = 300 + 64 - (ms.bounds.size.height - keyboardBounds.size.height);
    }
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.superView.translatesAutoresizingMaskIntoConstraints = YES;
    self.superView.frame = CGRectMake(0, 0 - height , self.superView.frame.size.width, self.superView.frame.size.height);
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.superView.frame = CGRectMake(0, 64 , self.superView.frame.size.width, self.superView.frame.size.height);
    [UIView commitAnimations];
}


-(void) initTopBar
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(tapLeftButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = rbbi;
    
    UIButton *srightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    srightButton.frame = CGRectMake(0, 0, 44, 44);
    [srightButton setTitle:@"保存" forState:UIControlStateNormal];
    [srightButton addTarget:self action:@selector(tapRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lbbi = [[UIBarButtonItem alloc] initWithCustomView:srightButton];
    self.navigationItem.rightBarButtonItem = lbbi;
}

-(void) tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) tapRightButton
{
    if (self.nameTextField.text == nil || [self.nameTextField.text isEqualToString:@""]) {
//        [kqAllTools showAlertViewWithTitle:@"提示" andMessage:@"请输入姓名!"];
        [kqAllTools showTipTextOnWindow:@"请输入姓名！"];
        return;
    }
    if ([self.staNameString isEqualToString:self.nameTextField.text] && [self.staNickNameString isEqualToString:self.nickNameTextField.text] && [self.staPositionString isEqualToString:self.postionTextField.text] && [self.staCompanyString isEqualToString:self.companyTextField.text] && (self.headerImage == nil)) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [kqAllTools showOnWindow:@"修改中"];
    kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
    dl.delegate = self;
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    if (self.headerImage) {
//        [dl requestModifyPersonalInfomationWithName:self.nameTextField.text andNickName:self.nickNameTextField.text andCompany:self.companyTextField.text andPostion:self.postionTextField.text andHeaderImage:self.headerImage];
        [dl uploadPictureToServiceWithImage:self.headerImage];
    }else{
//        [dl requestModifyPersonalInfomationWithName:self.nameTextField.text andNickName:self.nickNameTextField.text andCompany:self.companyTextField.text andPostion:self.postionTextField.text andHeaderImage:nil];
        [dl modifyUserInfomationWithUserName:self.nameTextField.text andNickname:self.nickNameTextField.text andEmail:[pinfo.userInfomation valueForKey:@"email"] andCompany:self.companyTextField.text andUserposition:self.postionTextField.text andUsericon:[pinfo.userInfomation valueForKey:@"usericon"]];
    }
}

-(void)uploadPictureToServiceDelegate:(NSDictionary *)rootDic
{
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
        kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
        dl.delegate = self;
        kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
        [dl modifyUserInfomationWithUserName:self.nameTextField.text andNickname:self.nickNameTextField.text andEmail:[pinfo.userInfomation valueForKey:@"email"] andCompany:self.companyTextField.text andUserposition:self.postionTextField.text andUsericon:[[rootDic valueForKey:@"data"] valueForKey:@"url"]];
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
}

-(void)modifyUserInfomationDelegate:(NSDictionary *)rootDic
{
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
        kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
        dl.delegate = self;
        [dl gainUserInfomation];
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
}

-(void)gainUserInfomationDelegate:(NSDictionary *)rootDic
{
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
        if ([[[[rootDic valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"usericon"] isKindOfClass:[NSString class]]) {
            NSString *urlString = [NSString stringWithFormat:@"%@",[[[rootDic valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"usericon"]];
            //        [self.headerImageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"zhanghuxinxi"]];
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"zhanghuxinxi"]];
        }
        kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
        pinfo.userInfomation = [[rootDic valueForKey:@"data"] valueForKey:@"user"];
        if (self.delegate) {
            [self.delegate didModifedPersonalInfomation];
        }
        [kqAllTools showAlertViewWithTitle:@"提示" andMessage:@"修改成功！"];
        
        [kqAllTools showTipTextOnWindow:@"修改成功！"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
}

//-(void)requestModifyPersonalInfomationDelegate:(NSDictionary *)rootDic
//{
//    [kqAllTools hidenHUD];
//    if ([[rootDic valueForKey:@"respMsg"] isEqualToString:@"请求成功"]) {
//        kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
//        if (!([rootDic valueForKey:@"userIcon"] == nil || [[rootDic valueForKey:@"userIcon"] isEqualToString:@""])) {
//            pinfo.userIcon = [NSString stringWithFormat:@"%@%@",[rootDic valueForKey:@"fileUrl"],[rootDic valueForKey:@"userIcon"]];
//        }
//        pinfo.hName = self.nameTextField.text;
//        pinfo.nickName = self.nickNameTextField.text;
//        pinfo.company = self.companyTextField.text;
//        pinfo.userPosition = self.postionTextField.text;
//        if (self.delegate) {
//            [self.delegate didModifedPersonalInfomation];
//        }
//        [kqAllTools showAlertViewWithTitle:@"提示" andMessage:@"修改成功！"];
//        [kqAllTools showTipTextOnWindow:@"修改成功！"];
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [kqAllTools showAlertViewWithTitle:@"提示" andMessage:[rootDic valueForKey:@"respMsg"]];
//    }
//}

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

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
//    [HNAGeneral showOnWindow:@"上传中"];
//    HNADownLoadManager *dl = [HNADownLoadManager sharedDownLoadManager];
//    dl.delegate = self;
//    [dl changeHeaderImageWith:editedImage];
    self.headerImageView.image = editedImage;
    self.headerImage = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [kqAllTools fixOrientation:portraitImg];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}
#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (IBAction)tapHeaderImageButton:(UITapGestureRecognizer *)sender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:@"修改头像"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    AppDelegate *app = (AppDelegate *)([UIApplication sharedApplication].delegate);
    [choiceSheet showInView:app.window];
    NSLog(@"1");
}

- (IBAction)tapResinFirstResponder:(UITapGestureRecognizer *)sender {
    [self.nameTextField resignFirstResponder];
    [self.nickNameTextField resignFirstResponder];
    [self.postionTextField resignFirstResponder];
    [self.companyTextField resignFirstResponder];
}
@end
