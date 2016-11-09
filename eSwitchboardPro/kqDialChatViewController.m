//
//  kqDialChatViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/30.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqDialChatViewController.h"
#import "LinphoneManager.h"
@interface kqDialChatViewController ()<kqDownloadManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *callNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *callStateLabel;
@property (strong, nonatomic) NSDate *startDate,*endDate;
@property (strong, nonatomic) NSTimer *scTimer;
@property (assign, nonatomic) NSInteger duration;
@property (weak, nonatomic) IBOutlet UIView *GongnengView;
@property (weak, nonatomic) IBOutlet UIView *keyBoardView;
@property (weak, nonatomic) IBOutlet UIButton *yinCangButton;
@property (weak, nonatomic) IBOutlet UILabel *fenjiLabel;
@property (assign, nonatomic) BOOL isMicro,isLaBa;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@end

@implementation kqDialChatViewController

-(void) startCall
{
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
     [[LinphoneManager instance] call:self.phoneNUmber displayName:pinfo.callNumber transfer:FALSE];
    for (NSDictionary *dict in pinfo.extenseionArray) {
        if ([self.phoneNUmber isEqualToString:[dict valueForKey:@"extnumber"]]) {
            if ([dict valueForKey:@"usericon"]) {
                if (![[dict valueForKey:@"usericon"] isKindOfClass:[NSNull class]]) {
                    [self.headerImageView setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"usericon"]]];
                }
            }
            if ([dict valueForKey:@"username"]) {
                if (![[dict valueForKey:@"username"] isKindOfClass:[NSNull class]]) {
                    self.callNameLabel.text = [dict valueForKey:@"username"];
                }else{
                    self.callNameLabel.hidden = YES;
                }
            }else{
                self.callNameLabel.hidden = YES;
            }
            break;
        }
    }
    kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
    NSString *content = [NSString stringWithFormat:@"%@的来电，请接听",pinfo.callNumber];
    NSArray *arr = [NSArray arrayWithObject:self.phoneNUmber];
    [dl sendJPushWithContent:content andAlias:arr];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callUpdateEvent:)
                                                 name:kLinphoneCallUpdate
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(coreUpdateEvent:)
                                                 name:kLinphoneCoreUpdate
                                               object:nil];
    
    // technically not needed, but older versions of linphone had this button
    // disabled by default. In this case, updating by pushing a new version with
    // xcode would result in the callbutton being disabled all the time.
    // We force it enabled anyway now.
    
    // Update on show
    LinphoneManager *mgr    = [LinphoneManager instance];
    LinphoneCore* lc        = [LinphoneManager getLc];
//    LinphoneCall* call      = linphone_core_get_current_call(lc);
//    LinphoneCallState state = (call != NULL)?linphone_call_get_state(call): 0;
//    [self callUpdate:call state:state];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneCallUpdate
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneCoreUpdate
                                                  object:nil];
}

#pragma mark - Event Functions

- (void)callUpdateEvent:(NSNotification*)notif {
    LinphoneCall *call = [[notif.userInfo objectForKey: @"call"] pointerValue];
    LinphoneCallState state = [[notif.userInfo objectForKey: @"state"] intValue];
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
//    [[LinphoneManager instance] call:self.phoneNUmber displayName:pinfo.callNumber transfer:FALSE];
    kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
    
    NSArray *arr = [NSArray arrayWithObject:self.phoneNUmber];
    switch (state) {
        case LinphoneCallError:
        {
            NSString *message = [notif.userInfo objectForKey: @"message"];
            NSLog(@"------------%@",message);
            if ([message isEqualToString:@"Not Found"]) {
//                [kqAllTools showAlertViewWithTitle:@"错误" andMessage:@"用户已关机！"];
                [kqAllTools showTipTextOnWindow:@"用户已关机！"];
            }else if([message isEqualToString:@"Bad Extension"]){
//                [kqAllTools showAlertViewWithTitle:@"错误" andMessage:@"账号不存在！"];
                [kqAllTools showTipTextOnWindow:@"账号不存在！"];
            }else if([message isEqualToString:@"Request Timeout"]){
//                [kqAllTools showAlertViewWithTitle:@"错误" andMessage:@"对方未接听！"];
                [kqAllTools showTipTextOnWindow:@"对方未接听！"];
                NSString *content = [NSString stringWithFormat:@"你有一个来自%@的未接来电",pinfo.callNumber];
                [dl sendJPushWithContent:content andAlias:arr];
            }
        }
            break;
        case LinphoneCallEnd:
        {
            NSString *message = [notif.userInfo objectForKey: @"message"];
            NSLog(@"------------%@",message);
            if ([message isEqualToString:@"Call declined."]) {
//                [kqAllTools showAlertViewWithTitle:@"错误" andMessage:@"对方拒绝接听！"];
                [kqAllTools showTipTextOnWindow:@"对方拒绝接听！"];
                NSString *content = [NSString stringWithFormat:@"你有一个来自%@的未接来电",pinfo.callNumber];
                [dl sendJPushWithContent:content andAlias:arr];
            }
        }
            break;
            
        default:
            break;
    }
    [self callUpdate:call state:state];
}

-(void)uploadCallRecoderDelegate:(NSDictionary *)rootDic
{
    
}

- (void)callUpdate:(LinphoneCall*)call state:(LinphoneCallState)state {
//    LinphoneCore *lc = [LinphoneManager getLc];
    switch (state) {
        case LinphoneCallError:
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            if (self.startDate) {
                self.endDate = [NSDate date];
                NSTimeInterval endti = [self.endDate timeIntervalSince1970];
                NSTimeInterval stati = [self.startDate timeIntervalSince1970];
                NSInteger cha = endti - stati;
                NSString *chaS = [NSString stringWithFormat:@"%li",(long)cha];
//                [[kqDataBase sharedDataBase] addRecoderDataWithPhoneNumber:self.phoneNUmber andCallTime:[formatter stringFromDate:[NSDate date]] andCallDuration:chaS andCallState:@"0"];
                
                kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
                dl.delegate = self;
                [dl uploadCallRecoderWithCallnumber:self.phoneNUmber andCallstatus:@"0" andCallduration:chaS andIslink:@"0" andCalltime:[formatter stringFromDate:self.startDate] andCallId:0];
                [self.scTimer invalidate];
            }else{
//                [[kqDataBase sharedDataBase] addRecoderDataWithPhoneNumber:self.phoneNUmber andCallTime:[formatter stringFromDate:[NSDate date]] andCallDuration:@"0" andCallState:@"0"];
                
                kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
                dl.delegate = self;
                [dl uploadCallRecoderWithCallnumber:self.phoneNUmber andCallstatus:@"0" andCallduration:@"0" andIslink:@"0" andCalltime:[formatter stringFromDate:[NSDate date]] andCallId:0];
            }
            [self dismissView];
        }
            break;
        case LinphoneCallEnd:
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            if (self.startDate) {
                self.endDate = [NSDate date];
                NSTimeInterval endti = [self.endDate timeIntervalSince1970];
                NSTimeInterval stati = [self.startDate timeIntervalSince1970];
                NSInteger cha = endti - stati;
                NSString *chaS = [NSString stringWithFormat:@"%li",(long)cha];
//                [[kqDataBase sharedDataBase] addRecoderDataWithPhoneNumber:self.phoneNUmber andCallTime:[formatter stringFromDate:[NSDate date]] andCallDuration:chaS andCallState:@"0"];
                
                kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
                dl.delegate = self;
                [dl uploadCallRecoderWithCallnumber:self.phoneNUmber andCallstatus:@"0" andCallduration:chaS andIslink:@"0" andCalltime:[formatter stringFromDate:self.startDate] andCallId:0];
                [self.scTimer invalidate];
            }else{
//                [[kqDataBase sharedDataBase] addRecoderDataWithPhoneNumber:self.phoneNUmber andCallTime:[formatter stringFromDate:[NSDate date]] andCallDuration:@"0" andCallState:@"0"];
                kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
                dl.delegate = self;
                [dl uploadCallRecoderWithCallnumber:self.phoneNUmber andCallstatus:@"0" andCallduration:@"0" andIslink:@"0" andCalltime:[formatter stringFromDate:[NSDate date]] andCallId:0];
            }
            [self dismissView];
        }
            break;
        case LinphoneCallConnected:
        {
            self.callStateLabel.text = @"00:00:00";
            self.startDate = [NSDate date];
            self.scTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(upDateLabelTime) userInfo:nil repeats:YES];
            self.duration = 0;
        }
            break;
        default:
            break;
    }
}

-(void) upDateLabelTime
{
    self.duration++;
    if (self.duration < 60) {
        if (self.duration < 10) {
            self.callStateLabel.text = [NSString stringWithFormat:@"00:00:0%ld",(long)self.duration];
        }else{
            self.callStateLabel.text = [NSString stringWithFormat:@"00:00:%ld",(long)self.duration];
        }
    }else if (self.duration >= 60 && self.duration < 3600){
        NSInteger minu = self.duration / 60;
        NSInteger seco = self.duration % 60;
        if (minu < 10) {
            if (seco < 10) {
                self.callStateLabel.text = [NSString stringWithFormat:@"00:0%ld:0%ld",(long)minu,(long)seco];
            }else{
                self.callStateLabel.text = [NSString stringWithFormat:@"00:0%ld:%ld",(long)minu,(long)seco];
            }
        }else{
            if (seco < 10) {
                self.callStateLabel.text = [NSString stringWithFormat:@"00:%ld:0%ld",(long)minu,(long)seco];
            }else{
                self.callStateLabel.text = [NSString stringWithFormat:@"00:%ld:%ld",(long)minu,(long)seco];
            }
        }
    }else{
        NSInteger hour = self.duration / 3600;
        NSInteger minu = (self.duration % 3600) / 60;
        NSInteger seco = (self.duration % 3600) % 60;
        if (hour < 10) {
            if (minu < 10) {
                if (seco < 10) {
                    self.callStateLabel.text = [NSString stringWithFormat:@"0%ld:0%ld:0%ld",(long)hour,(long)minu,(long)seco];
                }else{
                    self.callStateLabel.text = [NSString stringWithFormat:@"0%ld:0%ld:%ld",(long)hour,(long)minu,(long)seco];
                }
            }else{
                if (seco < 10) {
                    self.callStateLabel.text = [NSString stringWithFormat:@"0%ld:%ld:0%ld",(long)hour,(long)minu,(long)seco];
                }else{
                    self.callStateLabel.text = [NSString stringWithFormat:@"0%ld:%ld:%ld",(long)hour,(long)minu,(long)seco];
                }
            }
        }else{
            if (minu < 10) {
                if (seco < 10) {
                    self.callStateLabel.text = [NSString stringWithFormat:@"%ld:0%ld:0%ld",(long)hour,(long)minu,(long)seco];
                }else{
                    self.callStateLabel.text = [NSString stringWithFormat:@"%ld:0%ld:%ld",(long)hour,(long)minu,(long)seco];
                }
            }else{
                if (seco < 10) {
                    self.callStateLabel.text = [NSString stringWithFormat:@"%ld:%ld:0%ld",(long)hour,(long)minu,(long)seco];
                }else{
                    self.callStateLabel.text = [NSString stringWithFormat:@"%ld:%ld:%ld",(long)hour,(long)minu,(long)seco];
                }
            }
        }
    }
}

- (void)coreUpdateEvent:(NSNotification*)notif {
    
}

-(void) checkExtension
{
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    if (pinfo.extenseionArray) {
        if (pinfo.extenseionArray.count != 0) {
            for (NSDictionary *dic in pinfo.extenseionArray) {
                NSString *pstr = [NSString stringWithFormat:@"888888%@",[dic valueForKey:@"extensionNumber"]];
                NSString *ptr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"phoneNumber"]];
                if ([pstr isEqualToString:self.phoneNUmber]||[ptr isEqualToString:self.phoneNUmber]) {
                    self.fenjiLabel.text = [NSString stringWithFormat:@"分机8888%@",[dic valueForKey:@"extensionNumber"]];
                    self.phoneLabel.text = [dic valueForKey:@"phoneNumber"];
                    if ([ptr isEqualToString:self.phoneNUmber]) {
                        self.phoneNUmber = pstr;
                    }
                    return;
                }
            }
        }
    }
    self.fenjiLabel.hidden = YES;
    self.phoneLabel.text = self.displayNumber;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerImageView.layer.cornerRadius = 30.0f;
    self.headerImageView.layer.masksToBounds = YES;
    self.isMicro = NO;
    self.isLaBa = YES;
    [self checkExtension];
    self.GongnengView.hidden = NO;
    self.keyBoardView.hidden = YES;
    self.yinCangButton.hidden = YES;
    [self startCall];
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dismissView) userInfo:nil repeats:NO];
        // Do any additional setup after loading the view from its nib.
}

- (IBAction)tapCutButton:(UIButton *)sender {
    LinphoneCore* lc = [LinphoneManager getLc];
    LinphoneCall* currentcall = linphone_core_get_current_call(lc);
    if (linphone_core_is_in_conference(lc) || // In conference
        (linphone_core_get_conference_size(lc) > 0 && [self callCount:lc] == 0) // Only one conf
        ) {
        linphone_core_terminate_conference(lc);
    } else if(currentcall != NULL) { // In a call
        linphone_core_terminate_call(lc, currentcall);
    } else {
        const MSList* calls = linphone_core_get_calls(lc);
        if (ms_list_size(calls) == 1) { // Only one call
            linphone_core_terminate_call(lc,(LinphoneCall*)(calls->data));
        }
    }
}

- (bool)isInConference:(LinphoneCall*) call {
    if (!call)
        return false;
    return linphone_call_is_in_conference(call);
}

- (int)callCount:(LinphoneCore*) lc {
    int count = 0;
    const MSList* calls = linphone_core_get_calls(lc);
    
    while (calls != 0) {
        if (![self isInConference:((LinphoneCall*)calls->data)]) {
            count++;
        }
        calls = calls->next;
    }
    return count;
}

-(void) dismissView
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//TODO:功能按钮
- (IBAction)tapMicroButton:(UIButton *)sender {
    if (self.isMicro) {
        linphone_core_mute_mic([LinphoneManager getLc], false);
        self.isMicro = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"micro"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"micro_p"] forState:UIControlStateHighlighted];
    }else{
        linphone_core_mute_mic([LinphoneManager getLc], true);
        self.isMicro = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"micro"] forState:UIControlStateHighlighted];
        [sender setBackgroundImage:[UIImage imageNamed:@"micro_p"] forState:UIControlStateNormal];
    }
}

- (IBAction)tapKeyBoardButton:(UIButton *)sender {
    self.GongnengView.hidden = YES;
    self.keyBoardView.hidden = NO;
    self.yinCangButton.hidden = NO;
    
    self.fenjiLabel.hidden = YES;
    self.phoneLabel.hidden = YES;
    self.callNameLabel.hidden = YES;
}

- (IBAction)tapLaBaButton:(UIButton *)sender {
    if (self.isLaBa) {
        self.isLaBa = NO;
        [[LinphoneManager instance] setSpeakerEnabled:false];
        [sender setBackgroundImage:[UIImage imageNamed:@"laba"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"laba_p"] forState:UIControlStateHighlighted];
    }else{
        self.isLaBa = YES;
        [[LinphoneManager instance] setSpeakerEnabled:true];
        [sender setBackgroundImage:[UIImage imageNamed:@"laba"] forState:UIControlStateHighlighted];
        [sender setBackgroundImage:[UIImage imageNamed:@"laba_p"] forState:UIControlStateNormal];
    }
}

- (IBAction)tapYincangButton:(UIButton *)sender {
    self.GongnengView.hidden = NO;
    self.keyBoardView.hidden = YES;
    self.yinCangButton.hidden = YES;
    
    self.fenjiLabel.hidden = YES;
    self.phoneLabel.hidden = NO;
    
    if (![self.callNameLabel.text isEqualToString:@"正在呼叫..."]) {
        self.callNameLabel.hidden = NO;
    }
    
}
@end
