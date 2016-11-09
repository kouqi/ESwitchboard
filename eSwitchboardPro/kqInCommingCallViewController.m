//
//  kqInCommingCallViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/8/20.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqInCommingCallViewController.h"

@interface kqInCommingCallViewController ()<kqDownloadManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *callNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostssLabel;
@property (weak, nonatomic) IBOutlet UILabel *callTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *callNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *rejustButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *cutButton;
@property (strong, nonatomic) NSDate *startDate,*endDate;
@property (strong, nonatomic) NSTimer *scTimer;
@property (assign, nonatomic) NSInteger duration;
@property (weak, nonatomic) IBOutlet UIView *gongnengView;
@property (weak, nonatomic) IBOutlet UIView *keyBoardView;
@property (weak, nonatomic) IBOutlet UIButton *yinCangButton;
@property (assign, nonatomic) BOOL isMicro,isLaBa;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@end

@implementation kqInCommingCallViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callUpdateEvent:)
                                                 name:kLinphoneCallUpdate
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneCallUpdate
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerImageView.layer.cornerRadius = 30.0f;
    self.headerImageView.layer.masksToBounds = YES;
    self.isMicro = NO;
    self.isLaBa = NO;
    self.gongnengView.hidden = YES;
    self.keyBoardView.hidden = YES;
    self.yinCangButton.hidden = YES;
    [self update];
    [self callUpdate:self.call state:linphone_call_get_state(self.call)];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)tapRejustbutton:(UIButton *)sender {
    linphone_core_terminate_call([LinphoneManager getLc], self.call);
}

- (IBAction)tapAcceptButton:(UIButton *)sender {
    [[LinphoneManager instance] acceptCall:self.call];
    self.acceptButton.hidden = YES;
    self.rejustButton.hidden = YES;
    self.cutButton.hidden = NO;
    self.gongnengView.hidden = NO;
    self.keyBoardView.hidden = YES;
    self.yinCangButton.hidden = YES;
    
    self.callTimeLabel.hidden = NO;
    self.callTimeLabel.text = @"00:00:00";
    self.startDate = [NSDate date];
    self.scTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(upDateLabelTime) userInfo:nil repeats:YES];
    self.duration = 0;
}

- (IBAction)tapCutButton:(UIButton *)sender {
    linphone_core_terminate_call([LinphoneManager getLc], self.call);
}

#pragma mark - Event Functions

- (void)callUpdateEvent:(NSNotification*)notif {
    LinphoneCall *acall = [[notif.userInfo objectForKey: @"call"] pointerValue];
    LinphoneCallState astate = [[notif.userInfo objectForKey: @"state"] intValue];
    [self callUpdate:acall state:astate];
}


#pragma mark -

- (void)callUpdate:(LinphoneCall *)acall state:(LinphoneCallState)astate {
    if(self.call == acall && (astate == LinphoneCallEnd || astate == LinphoneCallError)) {
        self.endDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval endti = [self.endDate timeIntervalSince1970];
        kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
        dl.delegate = self;
        if (self.startDate) {
            NSTimeInterval stati = [self.startDate timeIntervalSince1970];
            NSInteger cha = endti - stati;
            NSString *chaS = [NSString stringWithFormat:@"%li",(long)cha];
            [dl uploadCallRecoderWithCallnumber:self.callNumberLabel.text andCallstatus:@"1" andCallduration:chaS andIslink:@"0" andCalltime:[formatter stringFromDate:self.startDate]andCallId:0];
        }else{
            [dl uploadCallRecoderWithCallnumber:self.callNumberLabel.text andCallstatus:@"1" andCallduration:@"0" andIslink:@"1" andCalltime:[formatter stringFromDate:[NSDate date]]andCallId:0];
        }
        
//        [[kqDataBase sharedDataBase] addRecoderDataWithPhoneNumber:self.callNumberLabel.text andCallTime:[formatter stringFromDate:[NSDate date]] andCallDuration:chaS andCallState:@"1"];
//        kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
//        dl.delegate = self;
//        if (cha <= 0) {
//            [dl uploadCallRecoderWithCallnumber:self.callNumberLabel.text andCallstatus:@"1" andCallduration:chaS andIslink:@"1" andCalltime:[formatter stringFromDate:[NSDate date]]andCallId:0];
//        }else{
//            
//        }
        [self.scTimer invalidate];
        [self.delegate incomingCallAborted:self.call];
    }
}

-(void)uploadCallRecoderDelegate:(NSDictionary *)rootDic
{
    
}

-(void) upDateLabelTime
{
    self.duration++;
    if (self.duration < 60) {
        if (self.duration < 10) {
            self.callTimeLabel.text = [NSString stringWithFormat:@"00:00:0%ld",(long)self.duration];
        }else{
            self.callTimeLabel.text = [NSString stringWithFormat:@"00:00:%ld",(long)self.duration];
        }
    }else if (self.duration >= 60 && self.duration < 3600){
        NSInteger minu = self.duration / 60;
        NSInteger seco = self.duration % 60;
        if (minu < 10) {
            if (seco < 10) {
                self.callTimeLabel.text = [NSString stringWithFormat:@"00:0%ld:0%ld",(long)minu,(long)seco];
            }else{
                self.callTimeLabel.text = [NSString stringWithFormat:@"00:0%ld:%ld",(long)minu,(long)seco];
            }
        }else{
            if (seco < 10) {
                self.callTimeLabel.text = [NSString stringWithFormat:@"00:%ld:0%ld",(long)minu,(long)seco];
            }else{
                self.callTimeLabel.text = [NSString stringWithFormat:@"00:%ld:%ld",(long)minu,(long)seco];
            }
        }
    }else{
        NSInteger hour = self.duration / 3600;
        NSInteger minu = (self.duration % 3600) / 60;
        NSInteger seco = (self.duration % 3600) % 60;
        if (hour < 10) {
            if (minu < 10) {
                if (seco < 10) {
                    self.callTimeLabel.text = [NSString stringWithFormat:@"0%ld:0%ld:0%ld",(long)hour,(long)minu,(long)seco];
                }else{
                    self.callTimeLabel.text = [NSString stringWithFormat:@"0%ld:0%ld:%ld",(long)hour,(long)minu,(long)seco];
                }
            }else{
                if (seco < 10) {
                    self.callTimeLabel.text = [NSString stringWithFormat:@"0%ld:%ld:0%ld",(long)hour,(long)minu,(long)seco];
                }else{
                    self.callTimeLabel.text = [NSString stringWithFormat:@"0%ld:%ld:%ld",(long)hour,(long)minu,(long)seco];
                }
            }
        }else{
            if (minu < 10) {
                if (seco < 10) {
                    self.callTimeLabel.text = [NSString stringWithFormat:@"%ld:0%ld:0%ld",(long)hour,(long)minu,(long)seco];
                }else{
                    self.callTimeLabel.text = [NSString stringWithFormat:@"%ld:0%ld:%ld",(long)hour,(long)minu,(long)seco];
                }
            }else{
                if (seco < 10) {
                    self.callTimeLabel.text = [NSString stringWithFormat:@"%ld:%ld:0%ld",(long)hour,(long)minu,(long)seco];
                }else{
                    self.callTimeLabel.text = [NSString stringWithFormat:@"%ld:%ld:%ld",(long)hour,(long)minu,(long)seco];
                }
            }
        }
    }
}

//- (void)dismiss {
//    if([[[PhoneMainView instance] currentView] equal:[IncomingCallViewController compositeViewDescription]]) {
//        [[PhoneMainView instance] popCurrentView];
//    }
//}

- (void)update {
    NSString* address = nil;
    const LinphoneAddress* addr = linphone_call_get_remote_address(self.call);
    if (addr != NULL) {
        // contact name
        char* lAddress = linphone_address_as_string_uri_only(addr);
        NSLog(@"%s",lAddress);
        if(lAddress) {
            const char* lDisplayName = linphone_address_get_display_name(addr);
            const char* lUserName = linphone_address_get_username(addr);
            if (lDisplayName)
                address = [NSString stringWithUTF8String:lDisplayName];
            else if(lUserName)
                address = [NSString stringWithUTF8String:lUserName];
        }
    }
    
    // Set Address
    if(address == nil) {
        address = @"Unknown";
    }
//    if (address.length > 8) {
//        NSString *display = [address substringFromIndex:2];
//        self.callNumberLabel.text = display;
//    }else{
    
        self.callNumberLabel.text = address;
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    for (NSDictionary *dict in pinfo.extenseionArray) {
        NSString *str = [NSString stringWithFormat:@"%@",[dict valueForKey:@"extnumber"]];
        if ([address isEqualToString:str]) {
            self.hostssLabel.hidden = NO;
            self.hostssLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"phonenumber"]];
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
//    }
}

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
    self.gongnengView.hidden = YES;
    self.keyBoardView.hidden = NO;
    self.yinCangButton.hidden = NO;
    self.headerImageView.hidden = YES;
    self.callNameLabel.hidden = YES;
    self.callTimeLabel.hidden = YES;
    self.callNumberLabel.hidden = YES;
    self.hostssLabel.hidden = YES;
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
    self.gongnengView.hidden = NO;
    self.keyBoardView.hidden = YES;
    self.yinCangButton.hidden = YES;
    
    self.headerImageView.hidden = NO;
    self.callNameLabel.hidden = NO;
    if (![self.callNameLabel.text isEqualToString:@"呼叫中"]) {
        self.callTimeLabel.hidden = NO;
    }
    self.callNumberLabel.hidden = NO;
    self.hostssLabel.hidden = NO;
}


#pragma mark - Property Functions

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

@end
