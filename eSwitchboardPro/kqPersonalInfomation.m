//
//  kqPersonalInfomation.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/25.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqPersonalInfomation.h"

@implementation kqPersonalInfomation
static kqPersonalInfomation *dl;
+(kqPersonalInfomation *)sharedPersonalInfomation
{
    @synchronized(self)
    {
        if (dl == nil) {
            dl = [[self alloc] init];
        }
        return dl;
    }
}
@end
