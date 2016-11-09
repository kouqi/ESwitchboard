//
//  kqValidateCodeLoginViewController.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/12/6.
//  Copyright © 2015年 海峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kqValidateCodeLoginViewController : UIViewController
@property(strong, nonatomic) NSString *cellphoneString;
@property(assign, nonatomic) id<kqDownloadManagerDelegate>delegate;
@end
