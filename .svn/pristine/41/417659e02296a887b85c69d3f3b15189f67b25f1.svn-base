//
//  kqHomeRightSelectView.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/27.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqHomeRightSelectView.h"

@implementation kqHomeRightSelectView
- (IBAction)tapCancelButton:(UITapGestureRecognizer *)sender {
    [self removeFromSuperview];
}

- (IBAction)tapDeleteButton:(UIButton *)sender {
    [self removeFromSuperview];
    [self.delegate didTapSelectToDeleteButton];
}

- (IBAction)tapChaxunButton:(UIButton *)sender {
    [self removeFromSuperview];
    [self.delegate didTapSelectToDateButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
