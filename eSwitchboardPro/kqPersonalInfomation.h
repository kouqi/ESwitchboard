//
//  kqPersonalInfomation.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/25.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kqPersonalInfomation : NSObject
@property(strong,nonatomic) NSString *callNumber;
@property(strong, nonatomic) NSMutableString *isfirstlogin,*ishost,*sippassword;
@property(strong,nonatomic) NSNumber *tokenNumber;
@property(strong, nonatomic) NSMutableDictionary *userInfomation,*eboHost,*eboExt;
@property(strong, nonatomic) NSMutableArray *extenseionArray,*callRecoderArray;
@property(assign, nonatomic) NSUInteger tabBarSelectedIndex;
//@property (assign, nonatomic) long userId,hostId;
+(kqPersonalInfomation *)sharedPersonalInfomation;
@end
