//
//  AppDelegate.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/6/3.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftViewController.h"
#import "kqLoginViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,LoginDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeftViewController *vc;

@end

