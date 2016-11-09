//
//  kqDownloadManager.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/25.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqDownloadManager.h"

@implementation kqDownloadManager
static kqDownloadManager *dl;
+(kqDownloadManager *)sharedDownLoadManager
{
    @synchronized(self)
    {
        if (dl == nil) {
            dl = [[self alloc] init];
        }
        return dl;
    }
}
//TODO:新版接口实现
//获取验证码
-(void) sendVerificationCodeWithCellPhoneNumber:(NSString *) cellPhoneNumber
{
    NSMutableDictionary *mdic=[[NSMutableDictionary alloc]init];
    [mdic setObject:cellPhoneNumber forKey:@"phonenumber"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:NO] forKey:@"messageheader"];
    [dict setValue:mdic forKey:@"data"];
    NSString *url=[NSString stringWithFormat:@"%@/system/mobile/authcode/send",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(sendVerificationCodeDelegate:)]) {
            [self.delegate sendVerificationCodeDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

//用户名密码登录
-(void) loginedWithCellPhoneNumber:(NSString *) cellPhoneNumber andPassword:(NSString *) password
{
    NSMutableDictionary *mdic=[[NSMutableDictionary alloc]init];
    [mdic setObject:cellPhoneNumber forKey:@"phonenumber"];
    [mdic setObject:password forKey:@"password"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:NO] forKey:@"messageheader"];
    [dict setValue:mdic forKey:@"data"];
    NSString *url=[NSString stringWithFormat:@"%@/user/password/login",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(loginedDelegate:)]) {
            [self.delegate loginedDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

//验证码登录
-(void) verificationCodeLoginedWithCellPhoneNumber:(NSString *) cellPhoneNumber andAuthcode:(NSString *) authcode
{
    NSMutableDictionary *mdic=[[NSMutableDictionary alloc]init];
    [mdic setObject:cellPhoneNumber forKey:@"phonenumber"];
    [mdic setObject:authcode forKey:@"authcode"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:NO] forKey:@"messageheader"];
    [dict setValue:mdic forKey:@"data"];
    NSString *url=[NSString stringWithFormat:@"%@/user/mobile/login",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(verificationCodeLoginedDelegate:)]) {
            [self.delegate verificationCodeLoginedDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

//注销登录
-(void) logout
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:YES] forKey:@"messageheader"];
    NSString *url=[NSString stringWithFormat:@"%@/user/logout",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(logoutDelegate:)]) {
            [self.delegate logoutDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

//获取用户信息
-(void) gainUserInfomation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:YES] forKey:@"messageheader"];
    NSString *url=[NSString stringWithFormat:@"%@/user/get",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(gainUserInfomationDelegate:)]) {
            [self.delegate gainUserInfomationDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}


//上传图片到服务器
-(void) uploadPictureToServiceWithImage:(UIImage *) dataImage
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:NO] forKey:@"messageheader"];
    NSString *url=[NSString stringWithFormat:@"%@/system/upload/photo",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"form-data; name=\"file\"" forHTTPHeaderField:@"Content-Disposition"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        UIImage *image = [UIImage imageNamed:@"aboutus"];
        NSData *imaData = UIImagePNGRepresentation(dataImage);
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
        NSString *fileName = [NSString stringWithFormat:@"%@.png",[dateFormater stringFromDate:[NSDate date]]];
        [formData appendPartWithFileData:imaData name:@"file" fileName:fileName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(uploadPictureToServiceDelegate:)]) {
            [self.delegate uploadPictureToServiceDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

//修改用户信息
-(void) modifyUserInfomationWithUserName:(NSString *) username andNickname:(NSString *) nickname andEmail:(NSString *) email andCompany:(NSString *) company andUserposition:(NSString *) userposition andUsericon:(NSString *) usericon
{
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    NSMutableDictionary *mmdic = [NSMutableDictionary dictionary];
    [mmdic setValue:[pinfo.userInfomation valueForKey:@"userid"] forKey:@"userid"];
    [mmdic setValue:[pinfo.userInfomation valueForKey:@"loginname"] forKey:@"loginname"];
    [mmdic setValue:username forKey:@"username"];
    [mmdic setValue:nickname forKey:@"nickname"];
    [mmdic setValue:email forKey:@"email"];
    [mmdic setValue:company forKey:@"company"];
    [mmdic setValue:userposition forKey:@"userposition"];
    [mmdic setValue:usericon forKey:@"usericon"];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setValue:mmdic forKey:@"user"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:YES] forKey:@"messageheader"];
    [dict setValue:mdic forKey:@"data"];
    NSString *url=[NSString stringWithFormat:@"%@/user/update",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(modifyUserInfomationDelegate:)]) {
            [self.delegate modifyUserInfomationDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

//修改密码
-(void) updatePasswordWithOldPassword:(NSString *) oldPassword andPassword:(NSString *) passwordnew
{
    NSMutableDictionary *mdic=[[NSMutableDictionary alloc]init];
    [mdic setObject:oldPassword forKey:@"password"];
    [mdic setObject:passwordnew forKey:@"newpassword"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:YES] forKey:@"messageheader"];
    [dict setValue:mdic forKey:@"data"];
    NSString *url=[NSString stringWithFormat:@"%@/user/password/update",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(updatePasswordDelegate:)]) {
            [self.delegate updatePasswordDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

//找回密码
-(void) foundPasswordWithPhonenumber:(NSString *) phonenumber andPassword:(NSString *) password andAuthcode:(NSString *) authcode
{
    NSMutableDictionary *mdic=[[NSMutableDictionary alloc]init];
    [mdic setObject:phonenumber forKey:@"phonenumber"];
    [mdic setObject:password forKey:@"password"];
    [mdic setObject:authcode forKey:@"authcode"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:NO] forKey:@"messageheader"];
    [dict setValue:mdic forKey:@"data"];
    NSString *url=[NSString stringWithFormat:@"%@/user/password/reset",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(foundPasswordDelegate:)]) {
            [self.delegate foundPasswordDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

//获取总机信息
-(void) gainHostInfomation
{
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    NSMutableDictionary *mmdic = [NSMutableDictionary dictionary];
    [mmdic setValue:[pinfo.eboHost valueForKey:@"hostid"] forKey:@"hostid"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:YES] forKey:@"messageheader"];
    [dict setValue:mmdic forKey:@"data"];
    NSString *url=[NSString stringWithFormat:@"%@/host/get",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(gainHostInfomationDelegate:)]) {
            [self.delegate gainHostInfomationDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

//获取分机列表
-(void) gainExtListWithType:(NSString *) type
{
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    NSMutableDictionary *mmdic = [NSMutableDictionary dictionary];
    [mmdic setValue:[pinfo.eboHost valueForKey:@"hostid"] forKey:@"hostid"];
    [mmdic setValue:type forKey:@"type"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:YES] forKey:@"messageheader"];
    [dict setValue:mmdic forKey:@"data"];
    NSString *url=[NSString stringWithFormat:@"%@/ext/list",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(gainExtListDelegate:)]) {
            [self.delegate gainExtListDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

//解绑或绑定分机  分机号为空则为解绑
-(void) bindExtPhoneNumberWithExtId:(long) extid andPhoneNumber:(NSString *) phonenumber
{
    NSMutableDictionary *mmdic = [NSMutableDictionary dictionary];
    [mmdic setValue:[NSNumber numberWithLong:extid] forKey:@"extid"];
    [mmdic setValue:phonenumber forKey:@"phonenumber"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:YES] forKey:@"messageheader"];
    [dict setValue:mmdic forKey:@"data"];
    NSString *url=[NSString stringWithFormat:@"%@/ext/bind",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(bindExtPhoneNumberDelegate:)]) {
            [self.delegate bindExtPhoneNumberDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

//上传通话记录
-(void) uploadCallRecoderWithCallnumber:(NSString *) callnumber andCallstatus:(NSString *) callstatus andCallduration:(NSString *) callduration andIslink:(NSString *) islink andCalltime:(NSString *) calltime andCallId:(int) callID
{
    NSMutableDictionary *mmdic = [NSMutableDictionary dictionary];
    if (callID != 0) {
        [mmdic setValue:[NSNumber numberWithLong:callID] forKey:@"callid"];
    }
//    [mmdic setValue:[NSNumber numberWithLong:callid] forKey:@"callid"];
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    [mmdic setValue:[pinfo.eboExt valueForKey:@"phonenumber"] forKey:@"phonenumber"];
    [mmdic setValue:callnumber forKey:@"callnumber"];
    [mmdic setValue:callstatus forKey:@"callstatus"];
    [mmdic setValue:callduration forKey:@"callduration"];
//    NSInteger duration = [callduration integerValue];
//    if ((duration == 0 || duration > 86400) && [callstatus isEqualToString:@"1"]) {
//        [mmdic setValue:@"1" forKey:@"islink"];
//    }else{
//        [mmdic setValue:@"0" forKey:@"islink"];
//    }
    [mmdic setValue:islink forKey:@"islink"];
    
    [mmdic setValue:calltime forKey:@"calltime"];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setValue:mmdic forKey:@"call"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:YES] forKey:@"messageheader"];
    [dict setValue:mdic forKey:@"data"];
    NSString *url=[NSString stringWithFormat:@"%@/call/add",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(uploadCallRecoderDelegate:)]) {
            [self.delegate uploadCallRecoderDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

//获取通话记录列表
-(void) gainCallRecorderListWithType:(NSString *) type andDate:(NSString *) date
{
    NSMutableDictionary *mmdic = [NSMutableDictionary dictionary];
    [mmdic setValue:[NSNumber numberWithInt:0] forKey:@"pagesize"];
    [mmdic setValue:[NSNumber numberWithInt:1] forKey:@"pagenumber"];
    [mmdic setValue:date forKey:@"date"];
    [mmdic setValue:type forKey:@"type"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:YES] forKey:@"messageheader"];
    [dict setValue:mmdic forKey:@"data"];
    NSString *url=[NSString stringWithFormat:@"%@/call/list",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(gainCallRecorderListDelegate:)]) {
            [self.delegate gainCallRecorderListDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

//删除通话记录列表
-(void) deleteCallRecorderWithIdlist:(NSArray *) idlist
{
    NSMutableDictionary *mmdic = [NSMutableDictionary dictionary];
    NSMutableArray *callIdArray = [NSMutableArray array];
    for (NSMutableDictionary *ddic in idlist) {
        [callIdArray addObject:[ddic valueForKey:@"callid"]];
    }
    [mmdic setValue:callIdArray forKey:@"idlist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[kqAllTools messageHeaderWithJianQuan:YES] forKey:@"messageheader"];
    [dict setValue:mmdic forKey:@"data"];
    NSString *url=[NSString stringWithFormat:@"%@/call/delete",MAIN_HOST];//你的接口地址
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([self.delegate respondsToSelector:@selector(deleteCallRecorderDelegate:)]) {
            [self.delegate deleteCallRecorderDelegate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

//TODO:end


////登录
//-(void) requestLoginWithLonginName:(NSString *) loginName andPassword:(NSString *) password
//{
////    NSString *urlString = [NSString stringWithFormat:@"%@host/host!findHostApp.action?code=%@&phoneNumber=%@",MAIN_HOST,password,loginName];
//    NSString *urlString = [NSString stringWithFormat:@"%@host/host!loginPasswordApp.action?phoneNumber=%@&password=%@",MAIN_HOST,loginName,password];
//    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    request.delegate = self;
//    request.tag = REQUEST_LOGIN;
//    [request setRequestMethod:@"GET"];
//    [request startAsynchronous];
//}
//
////获取账号信息
//-(void) requestAcountInfoWithLonginName:(NSString *) loginName andCode:(NSString *) code
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@host/host!findHostApp.action?code=%@&phoneNumber=%@",MAIN_HOST,code,loginName];
//    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    request.delegate = self;
//    request.tag = REQUEST_GETACCOUNTINFO;
//    [request setRequestMethod:@"GET"];
//    [request startAsynchronous];
//}

//获取通话记录
-(void) requestCallRecorderWithPhoneNumber:(NSString *) phoneNumber andPageNo:(NSInteger) pageNo
{
    NSString *urlString = [NSString stringWithFormat:@"%@call/call!listCallApp.action?phoneNumber=%@&pageNo=%ld",MAIN_HOST,phoneNumber,(long)pageNo];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.delegate = self;
    request.tag = REQUEST_CALLRECODER;
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
}

////获取分机号列表
//-(void) requestExtension
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@ext/ext!listApp.action?isExt=0",MAIN_HOST];
//    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    request.delegate = self;
//    request.tag = REQUEST_GETEXTENSION;
//    [request setRequestMethod:@"GET"];
//    [request startAsynchronous];
//}

////重置密码
//-(void) requestResetPasswordWithPhoneNumber:(NSString *) phoneNumber andOldPassword:(NSString *) oldPassword andNewPassword:(NSString *) newPassword
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@host/host!updatePasswordApp.action?phoneNumber=%@&password=%@&newPassword=%@",MAIN_HOST,phoneNumber,oldPassword,newPassword];
//    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    request.delegate = self;
//    request.tag = REQUEST_RESETPASSWORD;
//    [request setRequestMethod:@"GET"];
//    [request startAsynchronous];
//}

//绑定号码
//-(void) requestBingdingPhoneNumberWithPhoneNumber:(NSString *) phoneNumber andId:(NSString *) idString
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@/ext/ext!saveApp.action?phoneNumber=%@&id=%@",MAIN_HOST,phoneNumber,idString];
//    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    request.delegate = self;
//    request.tag = REQUEST_BINDINGNUMBER;
//    [request setRequestMethod:@"GET"];
//    [request startAsynchronous];
//}

//TODO:极光推送
-(void)sendJPushWithContent:(NSString *) msgContent andAlias:(NSArray *)aliasArray
{
    NSMutableString *aliasString = [NSMutableString stringWithFormat:@"\"alias\":["];
    for (NSString *aliasssString in aliasArray) {
        [aliasString appendFormat:@"\"%@\",",aliasssString];
    }
    NSMutableString *aliaString = [NSMutableString stringWithFormat:@"%@",[aliasString substringWithRange:NSMakeRange(0, aliasString.length - 1)]];
    [aliaString appendFormat:@"]"];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.jpush.cn/v3/push"];
    NSString *mbsae64String = [NSString stringWithFormat:@"%@:%@",JPUSHAPPKEY,JPUSHMASTERSECRET];
    NSString *base64 = [GTMBase64 stringByEncodingData:[mbsae64String dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *extras = [NSString stringWithFormat:@"{\"msgContent\":\"%@\"}",msgContent];
//    NSString *androids = [NSString stringWithFormat:@"\"android\":{\"alert\":\"%@\",\"title\":\"i宝贝\",\"builder_id\":1,\"extras\":%@},",msgContent,extras];
//    NSString *jsonStr = [NSString stringWithFormat:@"{\"platform\":[\"android\",\"ios\"],\"audience\":{%@},\"notification\":{%@\"ios\":{\"alert\":\"%@\",\"extras\":%@,\"badge\":\"1\",\"sound\":\"default\"}},\"options\":{\"sendno\":1740932926,\"apns_production\": false}}",aliaString,androids,msgContent,extras];
    NSString *jsonStr = [NSString stringWithFormat:@"{\"platform\":[\"ios\"],\"audience\":{%@},\"notification\":{\"ios\":{\"alert\":\"%@\",\"extras\":%@,\"badge\":\"1\",\"sound\":\"default\"}},\"options\":{\"sendno\":1740932926,\"apns_production\": %@}}",aliaString,msgContent,extras,APNS_PRODUCTION];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"Basic %@",base64]];
    [request setPostBody:[[NSMutableData alloc] initWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]]];
    request.delegate = self;
    request.tag = JPUSH_TAG;
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
}

-(void) requestModifyPersonalInfomationWithName:(NSString *) nameString andNickName:(NSString *) nickNameString andCompany:(NSString *) companyString andPostion:(NSString *) postionString andHeaderImage:(UIImage *) headerImage
{
    NSString *urlStr = [NSString stringWithFormat:@"%@host/host!editUser.action",MAIN_HOST];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = REQUEST_MODIFYPERSONALINFOMATION;
    [request setRequestMethod:@"POST"];
    if (headerImage) {
        NSData *imaData = UIImageJPEGRepresentation(headerImage, 0.5f);
        NSString *imageStr = [GTMBase64 stringByEncodingData:imaData];
        [request setPostValue:imageStr forKey:@"base64Code"];
//        [request setPostValue:imageStr forKey:@"file"];
        [request setPostValue:@"png" forKey:@"expand"];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyyMMddHHmmss"];
//        NSString *fileName = [formatter stringFromDate:[NSDate date]];
//        [request setPostValue:fileName forKey:@"fileName"];
    }
    [request setPostValue:nameString forKey:@"name"];
    [request setPostValue:nickNameString forKey:@"nickName"];
    [request setPostValue:companyString forKey:@"company"];
    [request setPostValue:postionString forKey:@"userPosition"];
    [request startAsynchronous];
}

//TODO:请求代理方法
/**
 *  <#Description#>
 *
 *  @param request <#request description#>
 */
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"--------------%@",request.responseString);
    if (request.tag == JPUSH_TAG) {
        return;
    }
    NSDictionary * rootDic = [[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:nil] objectAtIndex:0];
    if (request.tag == REQUEST_LOGIN) {
        if ([self.delegate respondsToSelector:@selector(requestLoginDelegate:)]) {
            [self.delegate requestLoginDelegate:rootDic];
        }
        return;
    }
    if (request.tag == REQUEST_CALLRECODER) {
        if ([self.delegate respondsToSelector:@selector(requestCallRecoderDelegate:)]) {
            [self.delegate requestCallRecoderDelegate:rootDic];
        }
        return;
    }
    if (request.tag == REQUEST_GETEXTENSION) {
        if ([self.delegate respondsToSelector:@selector(requestExtensionDelegate:)]) {
            [self.delegate requestExtensionDelegate:rootDic];
        }
        return;
    }
    if (request.tag == REQUEST_GETACCOUNTINFO) {
        if ([self.delegate respondsToSelector:@selector(requestAcountInfoDelegate:)]) {
            [self.delegate requestAcountInfoDelegate:rootDic];
        }
        return;
    }
    if (request.tag == REQUEST_RESETPASSWORD) {
        if ([self.delegate respondsToSelector:@selector(requestResetPasswordDelegate:)]) {
            [self.delegate requestResetPasswordDelegate:rootDic];
        }
        return;
    }
    if (REQUEST_BINDINGNUMBER == request.tag) {
        if ([self.delegate respondsToSelector:@selector(requestBingdingPhoneNumberDelegate:)]) {
            [self.delegate requestBingdingPhoneNumberDelegate:rootDic];
        }
    }
    if (REQUEST_MODIFYPERSONALINFOMATION == request.tag) {
        if ([self.delegate respondsToSelector:@selector(requestModifyPersonalInfomationDelegate:)]) {
            [self.delegate requestModifyPersonalInfomationDelegate:rootDic];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}
@end
