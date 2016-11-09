//
//  kqQiDongViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/11/15.
//  Copyright © 2015年 海峰. All rights reserved.
//

#import "kqQiDongViewController.h"

@interface kqQiDongViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation kqQiDongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius = 5.0f;
    self.loginButton.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapLoginButton:(UIButton *)sender {
    [self.delegate didTapLoginButton];
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
