//
//  kqDeleteCallRecorderTableViewCell.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/28.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqDeleteCallRecorderTableViewCell.h"

@implementation kqDeleteCallRecorderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initCellWithDictionary:(NSDictionary *) dic
{
    self.phoneNumberLabel.text = [dic valueForKey:@"callnumber"];
    if ([[dic valueForKey:@"callstatus"] isEqualToString:@"1"]) {
        self.callStateImageView.image = [UIImage imageNamed:@"dalout.png"];
    }else{
        self.callStateImageView.image = [UIImage imageNamed:@"dalin.png"];
    }
    NSInteger duration = [[dic valueForKey:@"callduration"] integerValue];
    if (duration < 60) {
        self.callLengthLabel.text = [NSString stringWithFormat:@"%@秒",[dic valueForKey:@"callduration"]];
    }else if (duration >= 60 && duration < 3600){
        NSInteger minu = duration / 60;
        NSInteger seco = duration % 60;
        self.callLengthLabel.text = [NSString stringWithFormat:@"%ld分%ld秒",(long)minu,(long)seco];
    }else{
        if (duration > 86400) {
            self.callLengthLabel.text = [NSString stringWithFormat:@"0秒"];
        }else{
            NSInteger hour = duration / 3600;
            NSInteger minu = (duration % 3600) / 60;
            NSInteger seco = (duration % 3600) % 60;
            self.callLengthLabel.text = [NSString stringWithFormat:@"%ld小时%ld分%ld秒",(long)hour,(long)minu,(long)seco];
        }
    }
    NSString *callTime = [dic valueForKey:@"calltime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *ct = [[callTime componentsSeparatedByString:@" "] objectAtIndex:0];
    NSString *nw = [formatter stringFromDate:[NSDate date]];
    if ([ct isEqualToString:nw]) {
        self.callTimeLabel.text = [NSString stringWithFormat:@"今天%@",[[callTime componentsSeparatedByString:@" "] objectAtIndex:1]];
    }else{
        self.callTimeLabel.text = [NSString stringWithFormat:@"%@",callTime];
    }
    if ([[dic valueForKey:@"flag"] boolValue]) {
        self.selectImageView.image = [UIImage imageNamed:@"checkon.png"];
    }else{
        self.selectImageView.image = [UIImage imageNamed:@"checkoff.png"];
    }
}

@end
