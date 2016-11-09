//
//  DialViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/6/12.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "DialViewController.h"
#import "kqDialExtensionViewController.h"
#import "kqDialChatViewController.h"
@interface DialViewController ()<UITextFieldDelegate,kqDownloadManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *localCallButton;

@end

@implementation DialViewController
- (IBAction)tapLocalCallButton:(UIButton *)sender {
    if (!(self.phoneNumberTextField.text == nil || [self.phoneNumberTextField.text isEqualToString:@""])) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumberTextField.text]]];
//        [[kqDataBase sharedDataBase] addRecoderDataWithPhoneNumber:self.phoneNumberTextField.text andCallTime:[formatter stringFromDate:[NSDate date]] andCallDuration:@"0" andCallState:@"0"];
        kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
        dl.delegate = self;
        [dl uploadCallRecoderWithCallnumber:self.phoneNumberTextField.text andCallstatus:@"0" andCallduration:@"0" andIslink:@"0" andCalltime:[formatter stringFromDate:[NSDate date]] andCallId:0];
//        kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
//        dl.delegate = self;
//        [dl uploadCallRecoderWithCallnumber:self.phoneNumberTextField.text andCallstatus:@"0" andCallduration:@"0" andIslink:@"0" andCalltime:[formatter stringFromDate:[NSDate date]]];
    }else{
//        [kqAllTools showAlertViewWithTitle:@"提示" andMessage:@"请输入电话"];
        [kqAllTools showTipTextOnWindow:@"请输入电话！"];
    }
}

-(void)uploadCallRecoderDelegate:(NSDictionary *)rootDic
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打电话";
    if (self.contactDictionary) {
        self.delButton.hidden = NO;
        self.contactName.hidden = NO;
        NSArray *phoneArray = [self.contactDictionary valueForKey:@"Phones"];
        if (phoneArray.count != 0) {
            self.phoneNumberTextField.text = [NSString stringWithFormat:@"%@",[phoneArray objectAtIndex:0]];
        }
        self.contactName.text = [self.contactDictionary valueForKey:@"LastName"];
    }
    CALayer *layer = self.callButton.layer;
    layer.cornerRadius = self.callButton.frame.size.height / 2;
    layer.masksToBounds = YES;
    
//    self.localCallButton.titleLabel.numberOfLines = 2;
    CALayer *layer2 = self.localCallButton.layer;
    layer2.cornerRadius = self.localCallButton.frame.size.height / 2;
    layer2.masksToBounds = YES;
//    [self initTopBar];
    // Do any additional setup after loading the view from its nib.
}

-(void) initTopBar
{
    UIButton *bu = [UIButton buttonWithType:UIButtonTypeCustom];
    bu.frame = CGRectMake(0, 0, 30, 30);
    [bu setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [bu addTarget:self action:@selector(tapRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithCustomView:bu];
    self.navigationItem.leftBarButtonItem = rbbi;
}

-(void) tapRightButton
{
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    self.tabBarController.selectedIndex = pinfo.tabBarSelectedIndex;
    self.tabBarController.tabBar.hidden = NO;
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

-(void) initstring
{
    if (self.contactDictionary) {
        self.delButton.hidden = NO;
        self.contactName.hidden = NO;
        NSArray *phoneArray = [self.contactDictionary valueForKey:@"Phones"];
        if (phoneArray.count != 0) {
            self.phoneNumberTextField.text = [NSString stringWithFormat:@"%@",[phoneArray objectAtIndex:0]];
        }
        self.contactName.text = [self.contactDictionary valueForKey:@"LastName"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapDeleteButton:(UIButton *)sender {
    NSString *xianshiStr = [NSString stringWithFormat:@"%@",self.phoneNumberTextField.text];
    if (xianshiStr.length == 1) {
        self.delButton.hidden = YES;
        self.phoneNumberTextField.text = @"";
        self.contactName.hidden = YES;
    }else{
        self.phoneNumberTextField.text = [xianshiStr substringWithRange:NSMakeRange(0, xianshiStr.length - 1)];
    }
}

- (IBAction)longPressDeleteButton:(UILongPressGestureRecognizer *)sender {
    self.phoneNumberTextField.text = @"";
    self.delButton.hidden = YES;
}

- (IBAction)tapNumberButton:(UIButton *)sender {
    NSString *xianshiStr = [NSString stringWithFormat:@"%@%@",self.phoneNumberTextField.text,sender.titleLabel.text];
    self.delButton.hidden = NO;
    self.phoneNumberTextField.text = xianshiStr;
}

- (IBAction)tapGongNengButton:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"拨分机"]) {
        self.hidesBottomBarWhenPushed = YES;
        kqDialExtensionViewController *devc = [[kqDialExtensionViewController alloc] initWithNibName:@"kqDialExtensionViewController" bundle:nil];
        [self.navigationController pushViewController:devc animated:YES];
    }else{
        if (!(self.phoneNumberTextField.text == nil || [self.phoneNumberTextField.text isEqualToString:@""])) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            if ([sender.titleLabel.text isEqualToString:@"本机呼叫"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumberTextField.text]]];
//                [[kqDataBase sharedDataBase] addRecoderDataWithPhoneNumber:self.phoneNumberTextField.text andCallTime:[formatter stringFromDate:[NSDate date]] andCallDuration:@"0" andCallState:@"0"];
                kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
                dl.delegate = self;
                [dl uploadCallRecoderWithCallnumber:self.phoneNumberTextField.text andCallstatus:@"0" andCallduration:@"0" andIslink:@"0" andCalltime:[formatter stringFromDate:[NSDate date]] andCallId:0];
                
//                kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
//                dl.delegate = self;
//                [dl uploadCallRecoderWithCallnumber:self.phoneNumberTextField.text andCallstatus:@"0" andCallduration:@"0" andIslink:@"0" andCalltime:[formatter stringFromDate:[NSDate date]]];
            }else{
                kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
                
                kqDialChatViewController *dcvc = [[kqDialChatViewController alloc] initWithNibName:@"kqDialChatViewController" bundle:nil];
                NSString *phoe;
                for (NSDictionary *dic in pinfo.extenseionArray) {
                    if ([[dic valueForKey:@"phonenumber"] isEqualToString:self.phoneNumberTextField.text]) {
                        phoe = [dic valueForKey:@"extnumber"];
                        break;
                    }
                }
                if (phoe) {
                    dcvc.phoneNUmber = phoe;
                }else{
                    dcvc.phoneNUmber = self.phoneNumberTextField.text;
                }
//                dcvc.phoneNUmber = self.phoneNumberTextField.text;
                dcvc.displayNumber = self.phoneNumberTextField.text;
                [self presentViewController:dcvc animated:YES completion:^{
                }];
            }
        }else{
//            [kqAllTools showAlertViewWithTitle:@"提示" andMessage:@"请输入电话"];
            [kqAllTools showTipTextOnWindow:@"请输入电话！"];
        }
    }
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
