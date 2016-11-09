//
//  kqDataBase.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/26.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqDataBase.h"

@implementation kqDataBase
static kqDataBase *dataBase;
+(kqDataBase *) sharedDataBase
{
    @synchronized(self){
        if (dataBase == nil) {
            dataBase = [[self alloc] init];
        }
    }
    return dataBase;
}

/**
 *  数据库路径
 *
 *  @return 数据库路径
 */
-(NSString *)dataBasePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathname = [path objectAtIndex:0];
    return [pathname stringByAppendingPathComponent:@"database.sqlite"];
}

/**
 *  打开数据库
 *
 *  @return 是否成功
 */
-(BOOL) openDataBase
{
    if (sqlite3_open([[self dataBasePath] UTF8String], &dataBase) != SQLITE_OK) { //根据指定目录打开数据库文件，如果没有就创建一个新的
        sqlite3_close(dataBase);
        printf("failed to open the database.\n");
        return NO;
    }
    else {
        printf("open the database successfully.\n");
        return YES;
    }
}

/**
 *  创建最近浏览表格
 *
 *  @return 是否成功
 */
-(BOOL) createCallRecoderTable
{
    if ([self openDataBase] == YES) {
        char *erroMsg;
        NSString *TableName = @"callTable";
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(userid INTEGER PRIMARY KEY AUTOINCREMENT, phoneNumber TEXT, callTime TEXT, callTDuration TEXT, callState TEXT, callFlag TEXT)", TableName];//创建一个表    AUTOINCREMENT 这里userid的值是创建表是自动生成的，从1开始依次自增
        if (sqlite3_exec(dataBase, [createSQL UTF8String], NULL, NULL, &erroMsg) != SQLITE_OK) {
            sqlite3_close(dataBase);
            printf("create table failed.\n");
            return NO;
        }
        else {
            printf("table was created.\n");
            return YES;
        }
    }
    else
        return NO;
}

/**
 *  添加纪录
 *
 *  @param dictionary 商品信息
 *  @param goodsId    商品ID
 *
 *  @return 是否成功
 */
-(BOOL) addRecoderDataWithPhoneNumber:(NSString *) phoneNumber andCallTime:(NSString *) callTime andCallDuration:(NSString *) callTDuration andCallState:(NSString *) callState
{
    if ([self openDataBase]) {
        char *update = "INSERT OR REPLACE INTO callTable(phoneNumber,callTime,callTDuration,callState,callFlag)""VALUES(?,?,?,?,?);";
        //上边的update也可以这样写：
        //NSString *insert = [NSString stringWithFormat:@"INSERT OR REPLACE INTO PERSIONINFO('%@','%@','%@','%@','%@')VALUES(?,?,?,?,?)",NAME,AGE,SEX,WEIGHT,ADDRESS];
        char *errorMsg = NULL;
        sqlite3_stmt *stmt;
        NSString *callFlag;
        if (!callFlag) {
            NSInteger duration = [callTDuration integerValue];
            if ((duration == 0 || duration > 86400) && [callState isEqualToString:@"1"]) {
                callFlag = @"1";
            }else{
                callFlag = @"0";
            }
        }
        if (sqlite3_prepare_v2(dataBase, update, -1, &stmt, nil) == SQLITE_OK) {
            //【插入数据】在这里我们使用绑定数据的方法，参数一：sqlite3_stmt，参数二：插入列号，参数三：插入的数据，参数四：数据长度（-1代表全部），参数五：是否需要回调
            sqlite3_bind_text(stmt, 1, [phoneNumber UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 2, [callTime UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 3, [callTDuration UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 4, [callState UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 5, [callFlag UTF8String], -1, NULL);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE){
            NSLog(@"数据更新失败");
            NSAssert(0, @"error updating :%s",errorMsg);
            return NO;
        }
        sqlite3_finalize(stmt);
        sqlite3_close(dataBase);
        return YES;
    }
    return NO;
}

-(BOOL) updateDataWithandCallFlag:(NSString *) callFlag andCallTime:(NSString *) callTime
{
    if ([self openDataBase]) {
        NSString *updateString = [NSString stringWithFormat:@"update callTable set callFlag='%@' where callTime='%@'",callFlag,callTime];
//        char *update = "INSERT OR REPLACE INTO callTable(phoneNumber,callTime,callTDuration,callState,callFlag)""VALUES(?,?,?,?,?);";
        //上边的update也可以这样写：
        //NSString *insert = [NSString stringWithFormat:@"INSERT OR REPLACE INTO PERSIONINFO('%@','%@','%@','%@','%@')VALUES(?,?,?,?,?)",NAME,AGE,SEX,WEIGHT,ADDRESS];
        char *errorMsg = NULL;
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(dataBase, [updateString UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            //【插入数据】在这里我们使用绑定数据的方法，参数一：sqlite3_stmt，参数二：插入列号，参数三：插入的数据，参数四：数据长度（-1代表全部），参数五：是否需要回调
            sqlite3_bind_text(stmt, 1, [callFlag UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 2, [callTime UTF8String], -1, NULL);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE){
            NSLog(@"数据更新失败");
            NSAssert(0, @"error updating :%s",errorMsg);
            return NO;
        }
        sqlite3_finalize(stmt);
        sqlite3_close(dataBase);
        return YES;
    }
    return NO;
}

-(BOOL)deleteRecoderWithCallTime:(NSString *)callTime
{
    if ([self openDataBase]) {
        char *errorMsg;
        NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM callTable where callTime=\"%@\"",callTime];
        const char *sql = [sqlStr UTF8String];
        if (sqlite3_exec(dataBase, sql, NULL, NULL, &errorMsg)==SQLITE_OK){
            NSLog(@"delete ok.");
            return YES;
        }else{
            NSLog( @"can not delete it" );
        }
    }
    return NO;
}

-(BOOL)deleteRecoderWithArray:(NSArray *) deleteArray
{
    for (NSDictionary *dic in deleteArray) {
        NSString *callTime = [dic valueForKey:@"callTime"];
        if (![self deleteRecoderWithCallTime:callTime]) {
            return NO;
        }
    }
    return YES;
}

/**
 *  检索所有商品
 *
 *  @return 返回商品数组
 */
-(NSArray *) queryAllRecoder
{
    NSMutableArray *arr = [NSMutableArray array];
    if ([self openDataBase]) {
        NSString *quary = @"SELECT * FROM callTable";//SELECT ROW,FIELD_DATA FROM FIELDS ORDER BY ROW
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(dataBase, [quary UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                const char *phoneNumberc = sqlite3_column_blob(stmt, 1);
                NSString *phoneNumber = [NSString stringWithUTF8String:phoneNumberc];
                const char *callTimec = sqlite3_column_blob(stmt, 2);
                NSString *callTime = [NSString stringWithUTF8String:callTimec];
                const char *callTDurationc = sqlite3_column_blob(stmt, 3);
                NSString *callTDuration = [NSString stringWithUTF8String:callTDurationc];
                const char *callStatec = sqlite3_column_blob(stmt, 4);
                NSString *callState = [NSString stringWithUTF8String:callStatec];
                const char *callFlagc = sqlite3_column_blob(stmt, 5);
                NSString *callFlag = [NSString stringWithUTF8String:callFlagc];
                NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
                [mdic setValue:phoneNumber forKey:@"phoneNumber"];
                [mdic setValue:callTime forKey:@"callTime"];
                [mdic setValue:callTDuration forKey:@"callTDuration"];
                [mdic setValue:callState forKey:@"callState"];
                [mdic setValue:callFlag forKey:@"callFlag"];
                [arr addObject:mdic];
            }
            sqlite3_finalize(stmt);
        }
        //用完了一定记得关闭，释放内存
        sqlite3_close(dataBase);
        NSMutableArray *rarr = [NSMutableArray arrayWithArray:[arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDictionary *dic1 = (NSDictionary *) obj1;
            NSDictionary *dic2 = (NSDictionary *) obj2;
            NSString *ct1 = [dic1 valueForKey:@"callTime"];
            NSString *ct2 = [dic2 valueForKey:@"callTime"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date1 = [formatter dateFromString:ct1];
            NSDate *date2 = [formatter dateFromString:ct2];
            NSComparisonResult result = [date2 compare:date1];
            return result;
        }]];
        return rarr;
    }
    return nil;
}


-(NSArray *) queryAllRecoderWithTime:(NSString *) time
{
    NSMutableArray *arr = [NSMutableArray array];
    if ([self openDataBase]) {
        NSString *quary = @"SELECT * FROM callTable";//SELECT ROW,FIELD_DATA FROM FIELDS ORDER BY ROW
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(dataBase, [quary UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                const char *callTimec = sqlite3_column_blob(stmt, 2);
                NSString *callTime = [NSString stringWithUTF8String:callTimec];
                if ([callTime containsString:time]) {
                    const char *phoneNumberc = sqlite3_column_blob(stmt, 1);
                    NSString *phoneNumber = [NSString stringWithUTF8String:phoneNumberc];
                    const char *callTDurationc = sqlite3_column_blob(stmt, 3);
                    NSString *callTDuration = [NSString stringWithUTF8String:callTDurationc];
                    const char *callStatec = sqlite3_column_blob(stmt, 4);
                    NSString *callState = [NSString stringWithUTF8String:callStatec];
                    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
                    [mdic setValue:phoneNumber forKey:@"phoneNumber"];
                    [mdic setValue:callTime forKey:@"callTime"];
                    [mdic setValue:callTDuration forKey:@"callTDuration"];
                    [mdic setValue:callState forKey:@"callState"];
                    [arr addObject:mdic];
                }
                
            }
            sqlite3_finalize(stmt);
        }
        //用完了一定记得关闭，释放内存
        sqlite3_close(dataBase);
        NSMutableArray *rarr = [NSMutableArray arrayWithArray:[arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDictionary *dic1 = (NSDictionary *) obj1;
            NSDictionary *dic2 = (NSDictionary *) obj2;
            NSString *ct1 = [dic1 valueForKey:@"callTime"];
            NSString *ct2 = [dic2 valueForKey:@"callTime"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSDate *date1 = [formatter dateFromString:ct1];
            NSDate *date2 = [formatter dateFromString:ct2];
            NSComparisonResult result = [date2 compare:date1];
            return result;
        }]];
        return rarr;
    }
    return nil;
}

//清空表数据
-(BOOL) deleteTableData
{
    if ([self openDataBase] == YES) {
        char *erroMsg;
        NSString *TableName = @"callTable";
        NSString *createSQL = [NSString stringWithFormat:@"DROP TABLE %@", TableName];//创建一个表    AUTOINCREMENT 这里userid的值是创建表是自动生成的，从1开始依次自增
        if (sqlite3_exec(dataBase, [createSQL UTF8String], NULL, NULL, &erroMsg) != SQLITE_OK) {
            sqlite3_close(dataBase);
            printf("delete table failed.\n");
            return NO;
        }
        else {
            printf("table was deleted.\n");
            return YES;
        }
    }
    else
        return NO;
}

@end
