//
//  LeftViewController.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/6/11.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController
//@property(strong, nonatomic) NSMutableDictionary *dataDictionary;
-(void) initDataArray;
- (void) verificationSignInWithUsername:(NSString*)username password:(NSString*)password domain:(NSString*)domain withTransport:(NSString*)transport;
@end
