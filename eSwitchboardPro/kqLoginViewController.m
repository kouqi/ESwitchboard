//
//  kqLoginViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/25.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqLoginViewController.h"
#import "kqLoginSendValidateViewController.h"
@interface kqLoginViewController ()<kqDownloadManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *superView;

@end

@implementation kqLoginViewController
- (IBAction)tapLoginIssueButton:(UIButton *)sender {
    kqLoginSendValidateViewController *lsvvc = [[kqLoginSendValidateViewController alloc] initWithNibName:@"kqLoginSendValidateViewController" bundle:nil];
    lsvvc.title = @"登录遇到问题";
    lsvvc.delegate = self;
    if (self.navigationController) {
        [self.navigationController pushViewController:lsvvc animated:YES];
    }else{
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lsvvc];
        [self presentViewController:navi animated:YES completion:^{
            
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginName.layer.cornerRadius = 5.0f;
    self.password.layer.cornerRadius = 5.0f;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [ud valueForKey:@"loginDic"];
    NSString *loginName = [dic valueForKey:@"loginName"];
    NSString *password = [dic valueForKey:@"password"];
    if (loginName) {
        self.loginName.text = loginName;
    }
    if (password) {
        self.password.text = password;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)tapCancelView:(UITapGestureRecognizer *)sender {
    [self.loginName resignFirstResponder];
    [self.password resignFirstResponder];
}

#pragma keyBoardNotification
-(void) keyboardWillShow:(NSNotification *)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.superView.translatesAutoresizingMaskIntoConstraints = YES;
    self.superView.frame = CGRectMake(0, 0 - self.loginName.frame.origin.y + 124 , self.superView.frame.size.width, self.superView.frame.size.height);
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.superView.frame = CGRectMake(0, 0 , self.superView.frame.size.width, self.superView.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)tapLoginButton:(UIButton *)sender {
    if ([self checkOut]) {
        kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
        dl.delegate = self;
//        [dl requestLoginWithLonginName:self.loginName.text andPassword:self.password.text];
        [dl loginedWithCellPhoneNumber:self.loginName.text andPassword:self.password.text];
        [kqAllTools showOnWindow:@"登录中"];
    }
}

-(BOOL)checkOut
{
    if ([kqAllTools checkTel:self.loginName.text]) {
        if (self.password.text.length == 0) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
        return YES;
    }
    return NO;
}

//-(void)requestLoginDelegate:(NSDictionary *)rootDic
//{
//    [kqAllTools hidenHUD];
//    if ([[rootDic valueForKey:@"respMsg"] isEqualToString:@"请求成功"]) {
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setValue:self.loginName.text forKey:@"loginName"];
//        [dic setValue:self.password.text forKey:@"password"];
//        [ud setValue:dic forKey:@"loginDic"];
//        [ud synchronize];
//    }
//    [self.delegate loginDelegete:rootDic];
//}

-(void)loginedDelegate:(NSDictionary *)rootDic
{
    
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
        [kqAllTools hidenHUD];
        [self verificationCodeLoginedDelegate:rootDic];
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
}

-(void)verificationCodeLoginedDelegate:(NSDictionary *)rootDic
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[[[rootDic valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"loginname"] forKey:@"loginName"];
    if (self.password.text.length != 0) {
        [dic setValue:self.password.text forKey:@"password"];
    }
    [ud setValue:dic forKey:@"loginDic"];
    [ud synchronize];
    [self.delegate loginDelegete:rootDic];
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
