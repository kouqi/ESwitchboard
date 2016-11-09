//
//  kqCallRecoderListViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/7/28.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqCallRecoderListViewController.h"
#import "kqHomeViewTableViewCell.h"
#import "kqCallRecoderDetailViewController.h"
@interface kqCallRecoderListViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation kqCallRecoderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopBar];
    UIScreen *ms = [UIScreen mainScreen];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ms.bounds.size.width, ms.bounds.size.height - 64.0f)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
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
    kqCallRecoderDetailViewController *crdvc = [[kqCallRecoderDetailViewController alloc] initWithNibName:@"kqCallRecoderDetailViewController" bundle:nil];
    crdvc.dataDicionary = [NSMutableDictionary dictionaryWithDictionary:[self.dataArray objectAtIndex:indexPath.row]];
    [crdvc initView];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:crdvc animated:YES];
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
