//
//  kqSettingViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/27.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqSettingViewController.h"
#import "kqResetPasswordViewController.h"
#import "AppDelegate.h"
#import "kqLoginViewController.h"
#import "kqBingdingNumberViewController.h"
#import "APService.h"
@interface kqSettingViewController ()
@property (weak, nonatomic) IBOutlet UIView *setAccountView;

@end

@implementation kqSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self initTopBar];
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    if ([pinfo.ishost isEqualToString:@"0"]) {
        self.setAccountView.hidden = NO;
    }else{
        self.setAccountView.hidden = YES;
    }
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapResetPasswordButton:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    kqResetPasswordViewController *rpVC = [[kqResetPasswordViewController alloc] initWithNibName:@"kqResetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:rpVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapZhuxiaoButton:(UIButton *)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [ud setValue:mdic forKey:@"loginDic"];
    [ud synchronize];
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *appdelegate = (AppDelegate *)app.delegate;
    kqLoginViewController *lvc = [[kqLoginViewController alloc] initWithNibName:@"kqLoginViewController" bundle:nil];
    lvc.delegate = appdelegate;
    appdelegate.window.rootViewController = lvc;
    [[kqDataBase sharedDataBase] deleteTableData];
    [APService setAlias:@"" callbackSelector:nil object:nil];
}

- (IBAction)tapSetAccountButton:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    kqBingdingNumberViewController *bnvc = [[kqBingdingNumberViewController alloc] initWithNibName:@"kqBingdingNumberViewController" bundle:nil];
    [self.navigationController pushViewController:bnvc animated:YES];
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
