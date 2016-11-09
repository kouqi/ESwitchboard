//
//  kqHomeViewTableViewCell.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/25.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqHomeViewTableViewCell.h"

@implementation kqHomeViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initCellWithDictionary:(NSDictionary *) dic
{
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    NSDictionary *mmdic;
    for (NSDictionary *ddic in pinfo.extenseionArray) {
        if ([[ddic valueForKey:@"extnumber"] isEqualToString:[dic valueForKey:@"callnumber"]]) {
            mmdic = [NSDictionary dictionaryWithDictionary:ddic];
            break;
        }
    }
    if (mmdic) {
        self.callNumberLabel.text = [dic valueForKey:@"callnumber"];
        if ([mmdic valueForKey:@"username"] && [[mmdic valueForKey:@"username"] isKindOfClass:[NSString class]]) {
            self.phoneNumberLabel.text = [mmdic valueForKey:@"username"];
        }else{
            self.cellPhoneY.constant = 20.0f;
            self.phoneNumberLabel.text = [dic valueForKey:@"callnumber"];
            self.callNumberLabel.hidden = YES;
        }
    }else{
        self.cellPhoneY.constant = 20.0f;
        self.phoneNumberLabel.text = [dic valueForKey:@"callnumber"];
        self.callNumberLabel.hidden = YES;
    }
    if ([[dic valueForKey:@"callstatus"] isEqualToString:@"0"]) {
        self.flagImageView.image = [UIImage imageNamed:@"dalout.png"];
    }else{
        self.flagImageView.image = [UIImage imageNamed:@"dalin.png"];
    }
    NSInteger duration = [[dic valueForKey:@"callduration"] integerValue];
    if (duration < 60) {
        self.longTimeLabel.text = [NSString stringWithFormat:@"%@秒",[dic valueForKey:@"callduration"]];
    }else if (duration >= 60 && duration < 3600){
        NSInteger minu = duration / 60;
        NSInteger seco = duration % 60;
        self.longTimeLabel.text = [NSString stringWithFormat:@"%ld分%ld秒",(long)minu,(long)seco];
    }else{
        if (duration > 86400) {
            self.longTimeLabel.text = [NSString stringWithFormat:@"0秒"];
        }else{
            NSInteger hour = duration / 3600;
            NSInteger minu = (duration % 3600) / 60;
            NSInteger seco = (duration % 3600) % 60;
            self.longTimeLabel.text = [NSString stringWithFormat:@"%ld小时%ld分%ld秒",(long)hour,(long)minu,(long)seco];
        }
    }
    NSString *callTime = [dic valueForKey:@"calltime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *ct = [formatter stringFromDate:[formatter dateFromString:[[callTime componentsSeparatedByString:@" "] objectAtIndex:0]]];
    NSString *nw = [formatter stringFromDate:[NSDate date]];
    if ([ct isEqualToString:nw]) {
        self.timeLabel.text = [NSString stringWithFormat:@"今天%@",[[callTime componentsSeparatedByString:@" "] objectAtIndex:1]];
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"%@",[[callTime componentsSeparatedByString:@" "] objectAtIndex:0]];
    }
    NSString *callFlag = [dic valueForKey:@"islink"];
    if ([callFlag isEqualToString:@"1"]) {
        self.phoneNumberLabel.textColor = [UIColor redColor];
    }else{
        self.phoneNumberLabel.textColor = RGB(75, 115, 176, 1);
    }
}

@end
