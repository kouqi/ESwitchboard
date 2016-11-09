//
//  kqAllTools.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/25.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqAllTools.h"
#import "AppDelegate.h"
@implementation kqAllTools


//获取接口头
+(NSMutableDictionary *) messageHeaderWithJianQuan:(BOOL) isNeed
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setValue:[dateFormater stringFromDate:[NSDate date]] forKey:@"timestamp"];
    [mdic setValue:REQUESTAPPKEY forKey:@"appkey"];
    [mdic setValue:REQUESTVERSION forKey:@"version"];
    if (isNeed) {
        kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
        [mdic setValue:pinfo.tokenNumber forKey:@"token"];
        [mdic setValue:[pinfo.userInfomation valueForKey:@"userid"] forKey:@"userid"];
    }
    return mdic;
}

//检测字符串是否是手机号
+ (BOOL)checkTel:(NSString *)str

{
    if ([str length] == 0) {
        [self showTipTextOnWindow:@"请输入手机号!"];
        return NO;
    }
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        [self showTipTextOnWindow:@"手机号格式错误!"];
        return NO;
    }
    return YES;
}


/**
 *  显示提示文字
 *
 *  @param text 提示文字
 */
+(void) showTipTextOnWindow:(NSString *) text
{
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *appdelegate = (AppDelegate *)app.delegate;
    MBProgressHUD *hud = (MBProgressHUD *)[appdelegate.window viewWithTag:10086];
    if (hud == nil) {
        hud = [[MBProgressHUD alloc] initWithView:appdelegate.window];
        hud.tag = 10086;
        [appdelegate.window addSubview:hud];
    }else{
        [hud removeFromSuperview];
        [appdelegate.window addSubview:hud];
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

/**
 *  进度菊花圈
 *
 *  @param text 显示的文字
 */
+ (void)showOnWindow:(NSString *) text
{
    // The hud will dispable all input on the window
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *appdelegate = (AppDelegate *)app.delegate;
    MBProgressHUD *hud = (MBProgressHUD *)[appdelegate.window viewWithTag:10086];
    if (hud == nil) {
        hud = [[MBProgressHUD alloc] initWithView:appdelegate.window];
        hud.tag = 10086;
        [appdelegate.window addSubview:hud];
    }else{
        [hud removeFromSuperview];
        [appdelegate.window addSubview:hud];
    }
    hud.labelText = text;
    [hud show:YES];
}

/**
 *  隐藏菊花圈
 */
+(void) hidenHUD
{
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *appdelegate = (AppDelegate *)app.delegate;
    MBProgressHUD *hud = (MBProgressHUD *)[appdelegate.window viewWithTag:10086];
    [hud hide:YES];
}

/**
 *  弹出警告框
 *
 *  @param title   框标题
 *  @param message 提示内容
 */
+(void) showAlertViewWithTitle:(NSString *) title andMessage:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
    [alert show];
}

/**
 *  矫正相册拍摄的照片保存读取后发生旋转90度
 *
 *  @param aImage 拍摄的照片
 *
 *  @return 处理后的照片
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage
{      // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;       // We need to calculate the proper transformation to make the image upright.     // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }       // Now we draw the underlying CGImage into a new context, applying the transform     // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,                                               CGImageGetBitsPerComponent(aImage.CGImage), 0,                                               CGImageGetColorSpace(aImage.CGImage),                                               CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:              // Grr...
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }       // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


@end