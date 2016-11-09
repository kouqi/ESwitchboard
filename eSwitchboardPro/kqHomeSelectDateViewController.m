//
//  kqHomeSelectDateViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/27.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqHomeSelectDateViewController.h"
#import "NSDate+convenience.h"
#import "kqCallRecoderListViewController.h"
@interface kqHomeSelectDateViewController ()<kqDownloadManagerDelegate>
@property(strong, nonatomic) NSString *monthString,*dateString;
@property(assign, nonatomic) BOOL isDate;
@end

@implementation kqHomeSelectDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"按日期查找";
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    UIScreen *ms = [UIScreen mainScreen];
    calendar.frame = CGRectMake(0, 64, calendar.frame.size.width, calendar.frame.size.height);
    calendar.center = CGPointMake(ms.bounds.size.width / 2, 64 + calendar.frame.size.height / 2);
    calendar.delegate=self;
    [self.view addSubview:calendar];
    [self initTopBar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.monthString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated andSwitchedToYear:(int)year{
    if (month < 10) {
        self.monthString = [NSString stringWithFormat:@"%d-0%d-01",year,month];
    }else{
        self.monthString = [NSString stringWithFormat:@"%d-%d-01",year,month];
    }
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.dateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    NSLog(@"Selected date = %@",date);
    self.isDate = YES;
     [kqAllTools showOnWindow:@"查询中"];
    kqDownloadManager *dl = [[kqDownloadManager alloc] init];
    dl.delegate = self;
    [dl gainCallRecorderListWithType:@"1" andDate:self.dateString];
    
//    self.hidesBottomBarWhenPushed = YES;
//    kqCallRecoderListViewController *crlvc = [[kqCallRecoderListViewController alloc] initWithNibName:@"kqCallRecoderListViewController" bundle:nil];
//    //    crlvc.dataArray
//    crlvc.title = self.dateString;
//    crlvc.dataArray = [NSMutableArray arrayWithArray:[[kqDataBase sharedDataBase] queryAllRecoderWithTime:self.dateString]];
//    [crlvc.tableView reloadData];
//    
//    [self.navigationController pushViewController:crlvc animated:YES];
}

-(void)gainCallRecorderListDelegate:(NSDictionary *)rootDic
{
    [kqAllTools hidenHUD];
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
        self.hidesBottomBarWhenPushed = YES;
        kqCallRecoderListViewController *crlvc = [[kqCallRecoderListViewController alloc] initWithNibName:@"kqCallRecoderListViewController" bundle:nil];
        //    crlvc.dataArray
        if (self.isDate) {
            crlvc.title = self.dateString;
        }else{
            crlvc.title = self.monthString;
        }
//        crlvc.title = self.dateString;
        
        if (crlvc.dataArray) {
            [crlvc.dataArray removeAllObjects];
        }else{
            crlvc.dataArray = [NSMutableArray array];
        }
        NSArray *arr = [[rootDic valueForKey:@"data"] valueForKey:@"ebocalllist"];
        if (arr.count > 0) {
            for (NSDictionary *dic in arr) {
                NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [crlvc.dataArray addObject:mdic];
            }
        }
        [crlvc.tableView reloadData];
        [self.navigationController pushViewController:crlvc animated:YES];
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
}

- (IBAction)tapMonthButton:(id)sender {
    self.isDate = NO;
    [kqAllTools showOnWindow:@"查询中"];
    kqDownloadManager *dl = [[kqDownloadManager alloc] init];
    dl.delegate = self;
    [dl gainCallRecorderListWithType:@"0" andDate:self.monthString];
//    self.hidesBottomBarWhenPushed = YES;
//    kqCallRecoderListViewController *crlvc = [[kqCallRecoderListViewController alloc] initWithNibName:@"kqCallRecoderListViewController" bundle:nil];
////    crlvc.dataArray
//    crlvc.title = self.monthString;
//    crlvc.dataArray = [NSMutableArray arrayWithArray:[[kqDataBase sharedDataBase] queryAllRecoderWithTime:self.monthString]];
//    [crlvc.tableView reloadData];
//    [self.navigationController pushViewController:crlvc animated:YES];
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
