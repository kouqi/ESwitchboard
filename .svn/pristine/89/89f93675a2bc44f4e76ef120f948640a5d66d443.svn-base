//
//  kqLoginViewController.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/25.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginDelegate <NSObject>

@optional
-(void) loginDelegete:(NSDictionary *) rootDic;

@end






@interface kqLoginViewController : UIViewController
@property(assign, nonatomic) id<LoginDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *loginName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@end
