//
//  kqLoginSendValidateViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/12/5.
//  Copyright © 2015年 海峰. All rights reserved.
//

#import "kqLoginSendValidateViewController.h"
#import "kqValidateCodeLoginViewController.h"
@interface kqLoginSendValidateViewController ()<kqDownloadManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cellPhoneTextField;

@end

@implementation kqLoginSendValidateViewController
- (IBAction)tapSelfView:(UITapGestureRecognizer *)sender {
    [self.cellPhoneTextField resignFirstResponder];
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
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
        kqValidateCodeLoginViewController *vclvc = [[kqValidateCodeLoginViewController alloc] initWithNibName:@"kqValidateCodeLoginViewController" bundle:nil];
        vclvc.title = @"验证码登录";
        vclvc.delegate = self.delegate;
        vclvc.cellphoneString = [NSString stringWithString:self.cellPhoneTextField.text];
        [self.navigationController pushViewController:vclvc animated:YES];
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
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
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellPhoneTextField.layer.cornerRadius = 5.0f;
    self.cellPhoneTextField.layer.masksToBounds = YES;
    self.cellPhoneTextField.layer.borderColor = RGB(0, 0, 0, 1.0).CGColor;
    self.cellPhoneTextField.layer.borderWidth = 0.5f;
    
    [self initTopBar];
    // Do any additional setup after loading the view from its nib.
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
