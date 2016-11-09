//
//  kqQiDongViewController.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/11/15.
//  Copyright © 2015年 海峰. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol kqQiDongViewControllerDelegate <NSObject>

@optional
-(void) didTapLoginButton;

@end




@interface kqQiDongViewController : UIViewController
@property(assign, nonatomic) id<kqQiDongViewControllerDelegate>delegate;
@end
