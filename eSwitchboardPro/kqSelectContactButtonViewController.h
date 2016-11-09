//
//  kqSelectContactButtonViewController.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/8/23.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol kqSelectContactDelegate <NSObject>

@optional
-(void) didSelectContactWithPhoneNumber:(NSString *) phoneNumber;

@end






@interface kqSelectContactButtonViewController : UIViewController
@property(assign, nonatomic) id<kqSelectContactDelegate>delegate;
@end
