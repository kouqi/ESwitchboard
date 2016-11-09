//
//  kqDeleteCallRecorderTableViewCell.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/28.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kqDeleteCallRecorderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *callStateImageView;
@property (weak, nonatomic) IBOutlet UILabel *callTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *callLengthLabel;
-(void) initCellWithDictionary:(NSDictionary *) dic;
@end
