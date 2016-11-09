//
//  kqBindingNumberDetailViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/8/22.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqBindingNumberDetailViewController.h"
#import "kqSelectContactButtonViewController.h"
@interface kqBindingNumberDetailViewController ()<kqSelectContactDelegate,kqDownloadManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *telePhoneNumberTextField;

@end

@implementation kqBindingNumberDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"云⋅总机";
    [self initTopBar];
    
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@",[self.dataDictionary valueForKey:@"extnumber"]];
    self.telePhoneNumberTextField.text = [NSString stringWithFormat:@"%@",[self.dataDictionary valueForKey:@"phonenumber"]];
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
    
    UIButton *bul = [UIButton buttonWithType:UIButtonTypeCustom];
    bul.frame = CGRectMake(0, 0, 40, 30);
//    [bul setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [bul setTitle:@"确定" forState:UIControlStateNormal];
    [bul addTarget:self action:@selector(tapEnterButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lbbi = [[UIBarButtonItem alloc] initWithCustomView:bul];
    self.navigationItem.rightBarButtonItem = lbbi;
}

-(void) tapRightButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) tapEnterButton
{
    [self.telePhoneNumberTextField resignFirstResponder];
    if (self.telePhoneNumberTextField.text == nil || [self.telePhoneNumberTextField.text isEqualToString:@""]) {
//        [kqAllTools showAlertViewWithTitle:@"提示" andMessage:@"请输入正确的电话"];
        [kqAllTools showTipTextOnWindow:@"请输入正确的电话！"];
    }else{
        [kqAllTools showOnWindow:@"加载中"];
        kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
        dl.delegate = self;
//        [dl requestBingdingPhoneNumberWithPhoneNumber:self.telePhoneNumberTextField.text andId:[self.dataDictionary valueForKey:@"id"]];
        [dl bindExtPhoneNumberWithExtId:[[self.dataDictionary valueForKey:@"extid"] longValue] andPhoneNumber:self.telePhoneNumberTextField.text];
    }
}

-(void)bindExtPhoneNumberDelegate:(NSDictionary *)rootDic
{
    
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
        [kqAllTools hidenHUD];
        [self.delegate didModifyBindingNumber];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapSelectContactButton:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    kqSelectContactButtonViewController *scbVC = [[kqSelectContactButtonViewController alloc] initWithNibName:@"kqSelectContactButtonViewController" bundle:nil];
    scbVC.delegate = self;
    [self.navigationController pushViewController:scbVC animated:YES];
}

-(void)didSelectContactWithPhoneNumber:(NSString *)phoneNumber
{
    self.telePhoneNumberTextField.text = phoneNumber;
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