//
//  kqBingdingNumberViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/8/22.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqBingdingNumberViewController.h"
#import "kqBindingNumberTableViewCell.h"
#import "kqBindingNumberDetailViewController.h"
@interface kqBingdingNumberViewController ()<UITableViewDataSource,UITableViewDelegate,kqDownloadManagerDelegate,kqModifyBindingNumberDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation kqBingdingNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScreen *ms = [UIScreen mainScreen];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80 + 64, ms.bounds.size.width, ms.bounds.size.height - 80 - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.title = @"号码绑定";
    [self initTopBar];
    
//    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
//    self.phoneLabel.text = pinfo.callNumber;
    
    kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
    dl.delegate = self;
    [dl gainExtListWithType:@""];
    [kqAllTools showOnWindow:@"加载中"];
    // Do any additional setup after loading the view from its nib.
}

-(void)gainExtListDelegate:(NSDictionary *)rootDic
{
    if ([[[rootDic valueForKey:@"messageheader"] valueForKey:@"errcode"] intValue] == 0) {
        [kqAllTools hidenHUD];
        if (self.dataArray) {
            [self.dataArray removeAllObjects];
        }else{
            self.dataArray = [NSMutableArray array];
        }
        NSArray *arr = [[rootDic valueForKey:@"data"] valueForKey:@"eboextlist"];
        if (arr.count > 0) {
            for (NSDictionary *dic in arr) {
                NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [self.dataArray addObject:mdic];
            }
        }
        [self.tableView reloadData];
    }else{
        [kqAllTools showTipTextOnWindow:[[rootDic valueForKey:@"messageheader"] valueForKey:@"errmsg"]];
    }
}

//-(void)requestExtensionDelegate:(NSDictionary *)rootDic
//{
//    [kqAllTools hidenHUD];
//    if ([[rootDic valueForKey:@"respMsg"] isEqualToString:@"请求成功"]) {
//        if (self.dataArray) {
//            [self.dataArray removeAllObjects];
//        }else{
//            self.dataArray = [NSMutableArray array];
//        }
//        [self.dataArray addObjectsFromArray:[rootDic valueForKey:@"data"]];
//        [self.tableView reloadData];
//    }else{
//        [kqAllTools showAlertViewWithTitle:@"提示" andMessage:[rootDic valueForKey:@"respMsg"]];
//    }
//}

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    kqBindingNumberTableViewCell *cell = (kqBindingNumberTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"kqBindingNumberTableViewCell" owner:self options:nil] objectAtIndex:0];
    [cell initCellWithIctionary:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.hidesBottomBarWhenPushed = YES;
    kqBindingNumberDetailViewController *bndvc= [[kqBindingNumberDetailViewController alloc] initWithNibName:@"kqBindingNumberDetailViewController" bundle:nil];
    bndvc.dataDictionary = [self.dataArray objectAtIndex:indexPath.row];
    bndvc.delegate = self;
    [self.navigationController pushViewController:bndvc animated:YES];
}

-(void)didModifyBindingNumber
{
//    kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
//    dl.delegate = self;
//    [dl requestExtension];
//    [kqAllTools showOnWindow:@"加载中"];
    kqDownloadManager *dl = [kqDownloadManager sharedDownLoadManager];
    dl.delegate = self;
    [dl gainExtListWithType:@""];
    [kqAllTools showOnWindow:@"加载中"];
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
