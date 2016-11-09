//
//  kqContactPhoneTableViewCell.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/9/21.
//  Copyright © 2015年 海峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol kqContactCellTapCallButtonDelegate <NSObject>

@optional
-(void) didTapCallButtonWithIndexPath:(NSIndexPath *) indexPath;

@end







@interface kqContactPhoneTableViewCell : UITableViewCell
@property (assign, nonatomic) id<kqContactCellTapCallButtonDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end
