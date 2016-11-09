//
//  AppDelegate.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/6/3.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "AppDelegate.h"
#import "LinphoneManager.h"
#import "kqInCommingCallViewController.h"
#import "APService.h"
#import "kqQiDongViewController.h"
@interface AppDelegate ()<kqDownloadManagerDelegate,IncomingCallViewDelegate,kqQiDongViewControllerDelegate>
@property (strong, nonatomic) kqInCommingCallViewController *incommingCallVc;
@end

@implementation AppDelegate


-(void)didTapLoginButton
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [ud valueForKey:@"loginDic"];
    NSString *loginName = [dic valueForKey:@"loginName"];
    NSString *password = [dic valueForKey:@"password"];
    kqLoginViewController *lvc = [[kqLoginViewController alloc] initWithNibName:@"kqLoginViewController" bundle:nil];
    lvc.delegate = self;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    lvc.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navi;
    if (loginName && password) {
        lvc.loginName.text = loginName;
        lvc.password.text = password;
        kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
        dl.delegate = self;
        [dl loginedWithCellPhoneNumber:loginName andPassword:password];
        [kqAllTools showOnWindow:@"加载中"];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithAppkey:MOBAPPKEY reportPolicy:BATCH   channelId:@""];
    [application setApplicationIconBadgeNumber:0];
    [[LinphoneManager instance] startLinphoneCore];
    
//    [[kqDownloadManager sharedDownLoadManager] uploadPictureToService];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(callUpdate:)
//                                                 name:kLinphoneCallUpdate
//                                               object:nil];
    // Required
    #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //categories
            [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound |
                                                 UIUserNotificationTypeAlert)
             categories:nil];
        } else {
            //categories nil
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
             categories:nil];
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#endif
             categories:nil];
        }
    
    [APService setupWithOption:launchOptions];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if ([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)]) {
        [[UINavigationBar appearance] setBarTintColor:RGB(75, 115, 176, 1)];
    }
    if ([UINavigationBar instancesRespondToSelector:@selector(setTitleTextAttributes:)]) {
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1 green:1 blue:1 alpha:1],NSForegroundColorAttributeName,nil]];
    }
    kqQiDongViewController *qid = [[kqQiDongViewController alloc] initWithNibName:@"kqQiDongViewController" bundle:nil];
    qid.delegate = self;
    self.window.rootViewController = qid;
    return YES;
}

//-(void)requestLoginDelegate:(NSDictionary *)rootDic
//{
//    [kqAllTools hidenHUD];
//    [self loginDelegete:rootDic];
//}

-(void)loginedDelegate:(NSDictionary *)rootDic
{
    [kqAllTools hidenHUD];
    [self loginDelegete:rootDic];
}

-(void)loginDelegete:(NSDictionary *)rootDic
{
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
        kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
        pinfo.userInfomation = [[rootDic valueForKey:@"data"] valueForKey:@"user"];
        pinfo.eboHost = [[rootDic valueForKey:@"data"] valueForKey:@"ebohost"];
        pinfo.eboExt = [[rootDic valueForKey:@"data"] valueForKey:@"eboext"];
        pinfo.ishost = [[rootDic valueForKey:@"data"] valueForKey:@"ishost"];
        pinfo.isfirstlogin = [[rootDic valueForKey:@"data"] valueForKey:@"isfirstlogin"];
        pinfo.sippassword = [[rootDic valueForKey:@"data"] valueForKey:@"sippassword"];
        pinfo.tokenNumber = [[rootDic valueForKey:@"data"] valueForKey:@"token"];
        
        kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
        dl.delegate = self;
        [dl gainExtListWithType:@"0"];
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
}

-(void)gainExtListDelegate:(NSDictionary *)rootDic
{
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
        kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
        if (pinfo.extenseionArray) {
            [pinfo.extenseionArray removeAllObjects];
        }else{
            pinfo.extenseionArray = [NSMutableArray array];
        }
        NSArray *arr = [[rootDic valueForKey:@"data"] valueForKey:@"eboextlist"];
        if (arr.count > 0) {
            for (NSDictionary *dic in arr) {
                NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [pinfo.extenseionArray addObject:mdic];
            }
        }
        //        [pinfo.extenseionArray addObjectsFromArray:[rootDic valueForKey:@"data"]];
        kqDownloadManager *dl = [[kqDownloadManager alloc] init];
        dl.delegate = self;
        [dl gainCallRecorderListWithType:nil andDate:nil];
        
//        [[kqDataBase sharedDataBase] createCallRecoderTable];
//        self.vc = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
//        self.window.rootViewController = self.vc;
//        [self.vc initDataArray];
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
}

-(void)gainCallRecorderListDelegate:(NSDictionary *)rootDic
{
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
        kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
        if (pinfo.callRecoderArray) {
            [pinfo.callRecoderArray removeAllObjects];
        }else{
            pinfo.callRecoderArray = [NSMutableArray array];
        }
        NSArray *arr = [[rootDic valueForKey:@"data"] valueForKey:@"ebocalllist"];
        if (arr.count > 0) {
            for (NSDictionary *dic in arr) {
                NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [pinfo.callRecoderArray addObject:mdic];
            }
        }
        //        [pinfo.extenseionArray addObjectsFromArray:[rootDic valueForKey:@"data"]];
//        [[kqDataBase sharedDataBase] createCallRecoderTable];
        self.vc = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
        self.window.rootViewController = self.vc;
        [self.vc initDataArray];
        
        
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
}

//-(void)requestExtensionDelegate:(NSDictionary *)rootDic
//{
//    if ([[rootDic valueForKey:@"respMsg"] isEqualToString:@"请求成功"]) {
//        kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
//        if (pinfo.extenseionArray) {
//            [pinfo.extenseionArray removeAllObjects];
//        }else{
//            pinfo.extenseionArray = [NSMutableArray array];
//        }
//        NSArray *arr = [rootDic valueForKey:@"data"];
//        if (arr.count > 0) {
//            for (NSDictionary *dic in arr) {
//                NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
//                [pinfo.extenseionArray addObject:mdic];
//            }
//        }
////        [pinfo.extenseionArray addObjectsFromArray:[rootDic valueForKey:@"data"]];
//        [[kqDataBase sharedDataBase] createCallRecoderTable];
//        self.vc = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
//        self.window.rootViewController = self.vc;
//        [self.vc initDataArray];
//    }else{
//        [kqAllTools showAlertViewWithTitle:@"提示" andMessage:[rootDic valueForKey:@"respMsg"]];
//    }
//}


- (void)callUpdate:(NSNotification*)notif {
    LinphoneCall *call = [[notif.userInfo objectForKey: @"call"] pointerValue];
    LinphoneCallState state = [[notif.userInfo objectForKey: @"state"] intValue];
    
    switch (state) {
        case LinphoneCallIncomingReceived:
        {
            [self displayIncomingCall:call];
            self.window.rootViewController = self.incommingCallVc;
            break;
        }
        case LinphoneCallIncomingEarlyMedia:
        case LinphoneCallOutgoingInit:
        case LinphoneCallPausedByRemote:
        case LinphoneCallConnected:
        case LinphoneCallStreamsRunning:
        case LinphoneCallUpdatedByRemote:
        case LinphoneCallError:
        case LinphoneCallEnd:
        default:
            break;
    }
}

- (void)displayIncomingCall:(LinphoneCall*) call{
    LinphoneCallLog* callLog = linphone_call_get_call_log(call);
    NSString* callId         = [NSString stringWithUTF8String:linphone_call_log_get_call_id(callLog)];
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        LinphoneManager* lm = [LinphoneManager instance];
        BOOL callIDFromPush = [lm popPushCallID:callId];
        BOOL autoAnswer     = [lm lpConfigBoolForKey:@"autoanswer_notif_preference"];
        
        if (callIDFromPush && autoAnswer){
            // accept call automatically
            [lm acceptCall:call];
        } else {
            self.incommingCallVc = [[kqInCommingCallViewController alloc] initWithNibName:@"kqInCommingCallViewController" bundle:nil];
            AudioServicesPlaySystemSound(lm.sounds.vibrate);
            if(self.incommingCallVc != nil) {
                [self.incommingCallVc setCall:call];
                [self.incommingCallVc setDelegate:self];
            }
            
        }
    }
}

-(void)incomingCallAborted:(LinphoneCall *)call
{
    self.window.rootViewController = self.vc;
}

- (void)incomingCallDeclined:(LinphoneCall*)call
{
    self.window.rootViewController = self.vc;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneCallUpdate
                                                  object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self setupBackgroundHandler];
}

- (void)setupBackgroundHandler
{
    if([[UIApplication sharedApplication] setKeepAliveTimeout:600 handler: ^{
            kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
            NSMutableString *logname;
            if ([pinfo.ishost intValue] == 0) {
                logname = [NSMutableString stringWithFormat:@"%@",[pinfo.eboHost valueForKey:@"hostnumber"]];
            }else{
                logname = [NSMutableString stringWithFormat:@"%@",[pinfo.eboExt valueForKey:@"extnumber"]];
            }
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [ud valueForKey:@"loginDic"];
            NSString *loginName = [dic valueForKey:@"loginName"];
            NSString *password = pinfo.sippassword;
            NSString *domin = @"182.92.224.250";
            NSString *transport = @"UDP";
            if (loginName) {
                [self.vc verificationSignInWithUsername:logname password:password domain:domin withTransport:transport];
            }
        }]){
        NSLog(@"Set Background handler successed!");
    }else{//failed
        NSLog(@"Set Background handler failed!");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    if( startedInBackground ){
//        startedInBackground = FALSE;
//        [[PhoneMainView instance] startUp];
//        [[PhoneMainView instance] updateStatusBar:nil];
//    }
    [application setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callUpdate:)
                                                 name:kLinphoneCallUpdate
                                               object:nil];
    LinphoneManager* instance = [LinphoneManager instance];

    [instance becomeActive];
    
    LinphoneCore* lc = [LinphoneManager getLc];
    LinphoneCall* call = linphone_core_get_current_call(lc);
    
    if (call){
//        [kqAllTools showAlertViewWithTitle:@"1" andMessage:@"1"];
        if (call == instance->currentCallContextBeforeGoingBackground.call) {
//            [kqAllTools showAlertViewWithTitle:@"2" andMessage:@"2"];
            const LinphoneCallParams* params = linphone_call_get_current_params(call);
            if (linphone_call_params_video_enabled(params)) {
                linphone_call_enable_camera(
                                            call,
                                            instance->currentCallContextBeforeGoingBackground.cameraIsEnabled);
//                [kqAllTools showAlertViewWithTitle:@"3" andMessage:@"3"];
            }
            instance->currentCallContextBeforeGoingBackground.call = 0;
        } else if ( linphone_call_get_state(call) == LinphoneCallIncomingReceived ) {
//            [kqAllTools showAlertViewWithTitle:@"4" andMessage:@"4"];
//            linphone_core_terminate_call([LinphoneManager getLc], call);
//            [[PhoneMainView  instance ] displayIncomingCall:call];
            
            [self displayIncomingCall:call];
            self.window.rootViewController = self.incommingCallVc;
            // in this case, the ringing sound comes from the notification.
            // To stop it we have to do the iOS7 ring fix...
//            [self fixRing];
        }
    }else{
//        [kqAllTools showAlertViewWithTitle:@"5" andMessage:@"5"];
    }
}

- (void)fixRing{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        // iOS7 fix for notification sound not stopping.
        // see http://stackoverflow.com/questions/19124882/stopping-ios-7-remote-notification-sound
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    }
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
