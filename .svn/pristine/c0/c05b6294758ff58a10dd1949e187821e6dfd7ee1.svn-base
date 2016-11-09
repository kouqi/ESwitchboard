//
//  kqDataBase.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/26.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface kqDataBase : NSObject
{
    sqlite3 *dataBase;
}
+(kqDataBase *) sharedDataBase;
-(BOOL) createCallRecoderTable;
-(BOOL) addRecoderDataWithPhoneNumber:(NSString *) phoneNumber andCallTime:(NSString *) callTime andCallDuration:(NSString *) callTDuration andCallState:(NSString *) callState;
-(BOOL) deleteRecoderWithCallTime:(NSString *) callTime;
-(NSArray *) queryAllRecoder;
-(BOOL)deleteRecoderWithArray:(NSArray *) deleteArray;
-(NSArray *) queryAllRecoderWithTime:(NSString *) time;
-(BOOL) deleteTableData;
-(BOOL) updateDataWithandCallFlag:(NSString *) callFlag andCallTime:(NSString *) callTime;
@end
