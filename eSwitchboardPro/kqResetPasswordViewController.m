//
//  kqResetPasswordViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/27.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqResetPasswordViewController.h"

@interface kqResetPasswordViewController ()<kqDownloadManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *fPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *sePasswordTextField;

@end

@implementation kqResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    [self initTopBar];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [ud valueForKey:@"loginDic"];
    NSString *loginName = [dic valueForKey:@"loginName"];
//    NSString *password = [dic valueForKey:@"password"];
    self.phoneNumberTextField.text = loginName;
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
    
    UIButton *rbu = [UIButton buttonWithType:UIButtonTypeCustom];
    rbu.frame = CGRectMake(0, 0, 50, 44);
    [rbu setTitle:@"确定" forState:UIControlStateNormal];
    [rbu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rbu setTitle:@"确定" forState:UIControlStateHighlighted];
    [rbu setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rbu addTarget:self action:@selector(tapEnterButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rrbbi = [[UIBarButtonItem alloc] initWithCustomView:rbu];
    self.navigationItem.rightBarButtonItem = rrbbi;
}

-(void) tapRightButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) tapEnterButton
{
    if (!([self.fPasswordTextField.text isEqualToString:@""] || self.fPasswordTextField.text == nil)) {
        if ([self.fPasswordTextField.text isEqualToString:self.sePasswordTextField.text]) {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [ud valueForKey:@"loginDic"];
//            NSString *loginName = [dic valueForKey:@"loginName"];
            NSString *password = [dic valueForKey:@"password"];
            kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
            dl.delegate = self;
            [dl updatePasswordWithOldPassword:password andPassword:self.fPasswordTextField.text];
            [kqAllTools showOnWindow:@"修改中"];
        }else{
//            [kqAllTools showAlertViewWithTitle:@"提示" andMessage:@"两次密码输入不一致"];
            [kqAllTools showTipTextOnWindow:@"两次密码输入不一致！"];
        }
    }else{
//        [kqAllTools showAlertViewWithTitle:@"提示" andMessage:@"请输入密码"];
        [kqAllTools showTipTextOnWindow:@"请输入密码！"];
    }
}

-(void)updatePasswordDelegate:(NSDictionary *)rootDic
{
//    [kqAllTools hidenHUD];
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
//        [self verificationCodeLoginedDelegate:rootDic];
        [kqAllTools showTipTextOnWindow:@"修改成功"];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [ud valueForKey:@"loginDic"];
        NSString *loginName = [dic valueForKey:@"loginName"];
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        [mdic setValue:loginName forKey:@"loginName"];
        [mdic setValue:self.fPasswordTextField.text forKey:@"password"];
        [ud setValue:mdic forKey:@"loginDic"];
        [ud synchronize];
        
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
}

-(void)requestResetPasswordDelegate:(NSDictionary *)rootDic
{
    [kqAllTools hidenHUD];
    [self.navigationController popViewControllerAnimated:YES];
    if ([[rootDic valueForKey:@"respMsg"] intValue] == 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [ud valueForKey:@"loginDic"];
        NSString *loginName = [dic valueForKey:@"loginName"];
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        [mdic setValue:loginName forKey:@"loginName"];
        [mdic setValue:self.fPasswordTextField.text forKey:@"password"];
        [ud setValue:mdic forKey:@"loginDic"];
        [ud synchronize];
    }
    [kqAllTools showAlertViewWithTitle:@"提示" andMessage:[rootDic valueForKey:@"respMsg"]];
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
