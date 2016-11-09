//
//  kqGenarl.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/6/15.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#ifndef eSwitchboardPro_kqGenarl_h
#define eSwitchboardPro_kqGenarl_h

#define RGB(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//#define MAIN_HOST @"http://182.92.224.250/ebo/"
//#define MAIN_HOST @"http://182.92.224.250/ebo-api/"//yunzhuji.5ikuma.com
#define MAIN_HOST @"http://yunzhuji.5ikuma.com/ebo-api/"
#define REQUEST_LOGIN 1001
#define REQUEST_CALLRECODER 1002
#define REQUEST_GETEXTENSION 1003
#define REQUEST_GETACCOUNTINFO 1004
#define REQUEST_RESETPASSWORD 1005
#define REQUEST_BINDINGNUMBER 1006
#define REQUEST_MODIFYPERSONALINFOMATION 1007

#define JPUSHAPPKEY @"a86cdaeb988e2a8b5fb5b25c"
#define JPUSHMASTERSECRET @"5b64907177c46efdd3428d94"
#define JPUSH_TAG 2017

#define APNS_PRODUCTION @true
//#define APNS_PRODUCTION @false


#define REQUESTAPPKEY @"c56a8a29-f62b-4d82-8646-cc9d8349b85e"
#define REQUESTVERSION @"1.0"
#define MOBAPPKEY @"56e6c7f667e58e9177000838"
#endif
