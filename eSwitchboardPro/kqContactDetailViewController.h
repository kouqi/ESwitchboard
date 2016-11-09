//
//  kqContactDetailViewController.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/9/20.
//  Copyright © 2015年 海峰. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol kqChangeMailListDelegate <NSObject>

@optional
-(void) didChangedTheMailList;

@end



@interface kqContactDetailViewController : UIViewController
@property (strong, nonatomic) NSMutableDictionary *phoneDictionary;
@property (assign, nonatomic) id<kqChangeMailListDelegate>delegate;
@end
