//
//  kqInCommingCallViewController.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/8/20.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IncomingCallViewDelegate <NSObject>
- (void)incomingCallAborted:(LinphoneCall*)call;
- (void)incomingCallDeclined:(LinphoneCall*)call;

@end

@interface kqInCommingCallViewController : UIViewController
@property (nonatomic, assign) LinphoneCall* call;
@property (nonatomic, retain) id<IncomingCallViewDelegate> delegate;
@end
