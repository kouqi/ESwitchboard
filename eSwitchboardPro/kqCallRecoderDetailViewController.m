//
//  kqCallRecoderDetailViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/28.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqCallRecoderDetailViewController.h"
#import "kqDialChatViewController.h"
@interface kqCallRecoderDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *callfangshiLabel;
@property (weak, nonatomic) IBOutlet UILabel *callTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *callTypeImage;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@end

@implementation kqCallRecoderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"呼叫详情";
    [self initView];
    [self initTopBar];
    // Do any additional setup after loading the view from its nib.
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


-(void) initView
{
    self.phoneNumberLabel.text = [self.dataDicionary valueForKey:@"callnumber"];
    if ([[self.dataDicionary valueForKey:@"callstatus"] isEqualToString:@"0"]) {
        self.callTypeImage.image = [UIImage imageNamed:@"dalout.png"];
        self.callfangshiLabel.text = @"呼出";
    }else{
        self.callTypeImage.image = [UIImage imageNamed:@"dalin.png"];
        self.callfangshiLabel.text = @"呼入";
    }
    NSInteger duration = [[self.dataDicionary valueForKey:@"callduration"] integerValue];
    if (duration < 60) {
        self.callTimeLabel.text = [NSString stringWithFormat:@"%@秒",[self.dataDicionary valueForKey:@"callduration"]];
    }else if (duration >= 60 && duration < 3600){
        NSInteger minu = duration / 60;
        NSInteger seco = duration % 60;
        self.callTimeLabel.text = [NSString stringWithFormat:@"%ld分%ld秒",(long)minu,(long)seco];
    }else{
        if (duration > 86400) {
            self.callTimeLabel.text = [NSString stringWithFormat:@"0秒"];
        }else{
            NSInteger hour = duration / 3600;
            NSInteger minu = (duration % 3600) / 60;
            NSInteger seco = (duration % 3600) % 60;
            self.callTimeLabel.text = [NSString stringWithFormat:@"%ld小时%ld分%ld秒",(long)hour,(long)minu,(long)seco];
        }
    }
}

- (IBAction)tapCallButton:(UIButton *)sender {
    kqDialChatViewController *dcvc = [[kqDialChatViewController alloc] initWithNibName:@"kqDialChatViewController" bundle:nil];
    dcvc.phoneNUmber = [self.dataDicionary valueForKey:@"callnumber"];
    dcvc.displayNumber = [self.dataDicionary valueForKey:@"callnumber"];
    [self presentViewController:dcvc animated:YES completion:^{
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

@end