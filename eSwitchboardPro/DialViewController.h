//
//  DialViewController.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/6/12.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "linphonecore.h"
@interface DialViewController : UIViewController
{
    LinphoneCore *lc;
}
@property (strong, nonatomic) NSMutableDictionary *contactDictionary;
-(void) initstring;

@end
