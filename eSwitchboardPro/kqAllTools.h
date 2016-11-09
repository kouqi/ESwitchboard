//
//  kqAllTools.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/25.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface kqAllTools : NSObject
+(NSMutableDictionary *) messageHeaderWithJianQuan:(BOOL) isNeed;
+(void) showTipTextOnWindow:(NSString *) text;
+ (void)showOnWindow:(NSString *) text;
+(void) hidenHUD;
+(void) showAlertViewWithTitle:(NSString *) title andMessage:(NSString *) message;
+ (UIImage *)fixOrientation:(UIImage *)aImage;
+ (BOOL)checkTel:(NSString *)str;
@end
