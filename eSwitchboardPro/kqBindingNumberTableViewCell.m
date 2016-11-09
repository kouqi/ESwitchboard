//
//  kqBindingNumberTableViewCell.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/8/22.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqBindingNumberTableViewCell.h"
@interface kqBindingNumberTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *fenjiLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@end
@implementation kqBindingNumberTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initCellWithIctionary:(NSDictionary *) rootDic
{
    self.backView.layer.borderWidth = 1.0f;
    self.fenjiLabel.text = [NSString stringWithFormat:@"%@",[rootDic valueForKey:@"extnumber"]];
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@",[rootDic valueForKey:@"phonenumber"]];
}

@end
