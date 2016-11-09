//
//  kqValidateCodeLoginViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/12/6.
//  Copyright © 2015年 海峰. All rights reserved.
//

#import "kqValidateCodeLoginViewController.h"

@interface kqValidateCodeLoginViewController ()<kqDownloadManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cellPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *validateCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *againSendValidateCodeButton;
@property (strong, nonatomic) NSTimer *timeer;
@property (assign, nonatomic) int secs;
@end

@implementation kqValidateCodeLoginViewController
- (IBAction)taptap:(UITapGestureRecognizer *)sender {
    [self.validateCodeTextField resignFirstResponder];
}

- (IBAction)tapCommitButton:(UIButton *)sender {
    if ([self.validateCodeTextField.text isEqualToString:@""] || self.validateCodeTextField.text == nil) {
        [kqAllTools showTipTextOnWindow:@"请输入验证码"];
    }else{
        kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
        dl.delegate = self;
        [dl verificationCodeLoginedWithCellPhoneNumber:self.cellPhoneTextField.text andAuthcode:self.validateCodeTextField.text];
    }
}

-(void)verificationCodeLoginedDelegate:(NSDictionary *)rootDic
{
    [self.cellPhoneTextField resignFirstResponder];
    [self.validateCodeTextField resignFirstResponder];
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
        [self.delegate verificationCodeLoginedDelegate:rootDic];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
}

- (IBAction)tapSendValidateCodeButton:(UIButton *)sender {
    if ([kqAllTools checkTel:self.cellPhoneTextField.text]) {
        kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
        dl.delegate = self;
        [dl sendVerificationCodeWithCellPhoneNumber:self.cellPhoneTextField.text];
    }
}

-(void)sendVerificationCodeDelegate:(NSDictionary *)rootDic
{
    
}

-(void) initTopBar
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(tapRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = rbbi;
}

-(void) tapRightButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopBar];
    self.cellPhoneTextField.text = self.cellphoneString;
    self.secs = 60;
    self.againSendValidateCodeButton.enabled = NO;
    self.timeer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(buttonTilleChange) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view from its nib.
}

-(void) buttonTilleChange
{
    self.secs--;
    if (self.secs != 0) {
        [self.againSendValidateCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重新获取验证码",self.secs] forState:UIControlStateNormal];
    }else{
        self.againSendValidateCodeButton.enabled = YES;
        [self.againSendValidateCodeButton setTitle:[NSString stringWithFormat:@"重新获取验证码"] forState:UIControlStateNormal];
        [self.timeer invalidate];
    }
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

@end
