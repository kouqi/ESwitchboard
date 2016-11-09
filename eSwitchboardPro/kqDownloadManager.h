//
//  kqDownloadManager.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/25.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "GTMBase64.h"
#import "AFNetworking.h"
@protocol kqDownloadManagerDelegate <NSObject>

@optional
-(void) requestLoginDelegate:(NSDictionary *) rootDic;
-(void) requestAcountInfoDelegate:(NSDictionary *) rootDic;
-(void) requestCallRecoderDelegate:(NSDictionary *) rootDic;
-(void) requestExtensionDelegate:(NSDictionary *) rootDic;
-(void) requestResetPasswordDelegate:(NSDictionary *) rootDic;
-(void) requestBingdingPhoneNumberDelegate:(NSDictionary *) rootDic;
-(void) requestModifyPersonalInfomationDelegate:(NSDictionary *) rootDic;


//TODO:新版接口代理
-(void) sendVerificationCodeDelegate:(NSDictionary *) rootDic;
-(void) loginedDelegate:(NSDictionary *) rootDic;
-(void) verificationCodeLoginedDelegate:(NSDictionary *) rootDic;
-(void) logoutDelegate:(NSDictionary *) rootDic;
-(void) gainUserInfomationDelegate:(NSDictionary *) rootDic;
-(void) uploadPictureToServiceDelegate:(NSDictionary *) rootDic;
-(void) modifyUserInfomationDelegate:(NSDictionary *) rootDic;
-(void) updatePasswordDelegate:(NSDictionary *) rootDic;
-(void) foundPasswordDelegate:(NSDictionary *) rootDic;
-(void) gainHostInfomationDelegate:(NSDictionary *) rootDic;
-(void) gainExtListDelegate:(NSDictionary *) rootDic;
-(void) bindExtPhoneNumberDelegate:(NSDictionary *) rootDic;
-(void) uploadCallRecoderDelegate:(NSDictionary *) rootDic;
-(void) gainCallRecorderListDelegate:(NSDictionary *) rootDic;
-(void) deleteCallRecorderDelegate:(NSDictionary *) rootDic;
//TODO:end
@end




@interface kqDownloadManager : NSObject<ASIHTTPRequestDelegate>
@property (assign, nonatomic) id<kqDownloadManagerDelegate>delegate;
+(kqDownloadManager *) sharedDownLoadManager;
//-(void) requestLoginWithLonginName:(NSString *) loginName andPassword:(NSString *) password;
//-(void) requestAcountInfoWithLonginName:(NSString *) loginName andCode:(NSString *) code;
//-(void) requestCallRecorderWithPhoneNumber:(NSString *) phoneNumber andPageNo:(NSInteger) pageNo;
//-(void) requestExtension;
//-(void) requestResetPasswordWithPhoneNumber:(NSString *) phoneNumber andOldPassword:(NSString *) oldPassword andNewPassword:(NSString *) newPassword;
//-(void) requestBingdingPhoneNumberWithPhoneNumber:(NSString *) phoneNumber andId:(NSString *) idString;
-(void)sendJPushWithContent:(NSString *) msgContent andAlias:(NSArray *)aliasArray;
//-(void) requestModifyPersonalInfomationWithName:(NSString *) nameString andNickName:(NSString *) nickNameString andCompany:(NSString *) companyString andPostion:(NSString *) postionString andHeaderImage:(UIImage *) headerImage;

//TODO:新版接口
-(void) sendVerificationCodeWithCellPhoneNumber:(NSString *) cellPhoneNumber;
-(void) loginedWithCellPhoneNumber:(NSString *) cellPhoneNumber andPassword:(NSString *) password;
-(void) verificationCodeLoginedWithCellPhoneNumber:(NSString *) cellPhoneNumber andAuthcode:(NSString *) authcode;
-(void) logout;
-(void) gainUserInfomation;
-(void) uploadPictureToServiceWithImage:(UIImage *) dataImage;
-(void) modifyUserInfomationWithUserName:(NSString *) username andNickname:(NSString *) nickname andEmail:(NSString *) email andCompany:(NSString *) company andUserposition:(NSString *) userposition andUsericon:(NSString *) usericon;
-(void) updatePasswordWithOldPassword:(NSString *) oldPassword andPassword:(NSString *) passwordnew;
-(void) foundPasswordWithPhonenumber:(NSString *) phonenumber andPassword:(NSString *) password andAuthcode:(NSString *) authcode;
-(void) gainHostInfomation;
-(void) gainExtListWithType:(NSString *) type;
-(void) bindExtPhoneNumberWithExtId:(long) extid andPhoneNumber:(NSString *) phonenumber;
-(void) uploadCallRecoderWithCallnumber:(NSString *) callnumber andCallstatus:(NSString *) callstatus andCallduration:(NSString *) callduration andIslink:(NSString *) islink andCalltime:(NSString *) calltime andCallId:(int) callID;
-(void) gainCallRecorderListWithType:(NSString *) type andDate:(NSString *) date;
-(void) deleteCallRecorderWithIdlist:(NSArray *) idlist;
//TODO:end
@end
