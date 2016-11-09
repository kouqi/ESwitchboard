//
//  HomeViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/6/11.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "HomeViewController.h"
#import "kqHomeViewTableViewCell.h"
#import "AppDelegate.h"
#import "kqHomeRightSelectView.h"
#import "kqHomeSelectDateViewController.h"
#import "kqCallRecoderDetailViewController.h"
#import "kqDeleteCallRecorderViewController.h"
@interface HomeViewController ()<kqHomeRightSelectViewDelegate,kqDownloadManagerDelegate>
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self initTopBar];
    UIScreen *ms = [UIScreen mainScreen];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ms.bounds.size.width, ms.bounds.size.height - 44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)gainCallRecorderListDelegate:(NSDictionary *)rootDic
{
    [kqAllTools hidenHUD];
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
        kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
        if (pinfo.callRecoderArray) {
            [pinfo.callRecoderArray removeAllObjects];
        }else{
            pinfo.callRecoderArray = [NSMutableArray array];
        }
        NSArray *arr = [[rootDic valueForKey:@"data"] valueForKey:@"ebocalllist"];
        if (arr.count > 0) {
            for (NSDictionary *dic in arr) {
                NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [pinfo.callRecoderArray addObject:mdic];
            }
        }
        //        [pinfo.extenseionArray addObjectsFromArray:[rootDic valueForKey:@"data"]];
        //        [[kqDataBase sharedDataBase] createCallRecoderTable];
        self.dataArray = [NSMutableArray arrayWithArray:pinfo.callRecoderArray];
        NSInteger badge = 0;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSMutableArray *dataArr = [ud valueForKey:@"callidArray"];
        for (NSDictionary *dic in self.dataArray) {
            NSString *callFlag = [dic valueForKey:@"islink"];
            if ([callFlag isEqualToString:@"1"]) {
                NSNumber *callid = [dic valueForKey:@"callid"];
                if (dataArr) {
                    if (![dataArr containsObject:callid]) {
                        badge++;
                    }
                }else{
                    badge++;
                }
            }
        }
        if (badge > 0) {
            if ([ud valueForKey:@"callBadgeFlag"]) {
                if (![[ud valueForKey:@"callBadgeFlag"] boolValue]) {
                    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",(long)badge]];
                }
            }else{
                [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",(long)badge]];
            }
            
        }else{
            [self.tabBarItem setBadgeValue:nil];
        }
        [self.tableView reloadData];
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    kqDownloadManager *dl = [[kqDownloadManager alloc] init];
    dl.delegate = self;
    [dl gainCallRecorderListWithType:nil andDate:nil];
    
//    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
//    self.dataArray = [NSMutableArray arrayWithArray:[[kqDataBase sharedDataBase] queryAllRecoder]];
//    self.dataArray = [NSMutableArray arrayWithArray:pinfo.callRecoderArray];
//    NSInteger badge = 0;
//    for (NSDictionary *dic in self.dataArray) {
//        NSString *callFlag = [dic valueForKey:@"islink"];
//        if ([callFlag isEqualToString:@"1"]) {
//            badge++;
//        }
//    }
//    if (badge > 0) {
//        [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",(long)badge]];
//    }else{
//        [self.tabBarItem setBadgeValue:nil];
//    }
//    [self.tableView reloadData];
}

-(void) initTopBar
{
    UIBarButtonItem *lbbi = [[UIBarButtonItem alloc] initWithCustomView:self.leftBackButton];
    self.navigationItem.leftBarButtonItem = lbbi;
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(0, 0, 44, 44);
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"homeRightButton.png"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(tapRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rbbi;
}

-(void) tapRightButton
{
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *appdelegate = (AppDelegate *)app.delegate;
    kqHomeRightSelectView *hrsv = (kqHomeRightSelectView *)[[[NSBundle mainBundle] loadNibNamed:@"kqHomeRightSelectView" owner:self options:nil] objectAtIndex:0];
    hrsv.frame = appdelegate.window.bounds;
    hrsv.delegate = self;
    [appdelegate.window addSubview:hrsv];
}

//TODO:选择模式代理
-(void)didTapSelectToDateButton
{
    self.hidesBottomBarWhenPushed = YES;
    kqHomeSelectDateViewController *hsdvc = [[kqHomeSelectDateViewController alloc] initWithNibName:@"kqHomeSelectDateViewController" bundle:nil];
    [self.navigationController pushViewController:hsdvc animated:YES];
}

-(void)didTapSelectToDeleteButton
{
    self.hidesBottomBarWhenPushed = YES;
    kqDeleteCallRecorderViewController *dcrvc = [[kqDeleteCallRecorderViewController alloc] initWithNibName:@"kqDeleteCallRecorderViewController" bundle:nil];
    [self.navigationController pushViewController:dcrvc animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
//    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    kqHomeViewTableViewCell *cell = (kqHomeViewTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"kqHomeViewTableViewCell" owner:self options:nil] objectAtIndex:0];
    [cell initCellWithDictionary:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    NSString *callFlag = [dic valueForKey:@"islink"];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *dataArr = [ud valueForKey:@"callidArray"];
    NSInteger badge = 0;
    if ([callFlag isEqualToString:@"1"]) {
        NSNumber *callid = [dic valueForKey:@"callid"];
        if (dataArr) {
            if (![dataArr containsObject:callid]) {
                NSMutableArray *dataArray = [NSMutableArray arrayWithArray:dataArr];
                [dataArray addObject:callid];
                [ud setValue:dataArray forKey:@"callidArray"];
                badge++;
            }
        }else{
            NSMutableArray *dataArray = [NSMutableArray array];
            [dataArray addObject:callid];
            [ud setValue:dataArray forKey:@"callidArray"];
            badge++;
        }
    }
    [ud synchronize];
    
    kqCallRecoderDetailViewController *crdvc = [[kqCallRecoderDetailViewController alloc] initWithNibName:@"kqCallRecoderDetailViewController" bundle:nil];
    crdvc.dataDicionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    [crdvc initView];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:crdvc animated:YES];
    [self.tableView reloadData];
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
