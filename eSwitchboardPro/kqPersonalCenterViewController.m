//
//  kqPersonalCenterViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/9/20.
//  Copyright © 2015年 海峰. All rights reserved.
//

#import "kqPersonalCenterViewController.h"
#import "kqLeftTableViewCell.h"
#import "kqSettingViewController.h"
#import "kqPIFTableViewCell.h"
#import "kqEditPersonalCenterViewController.h"
@interface kqPersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate,kqModifyPersonalInfomationDelegate>
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *displayArray;
@end

@implementation kqPersonalCenterViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScreen *ms = [UIScreen mainScreen];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ms.bounds.size.width, ms.bounds.size.height-49.0f)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

-(void) initTableViewWithDictionary:(NSDictionary *) rootDic
{
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    self.dataDictionary = [NSMutableDictionary dictionaryWithDictionary:pinfo.eboHost];
    //tableview显示相关
    NSMutableString *str1 = [NSMutableString stringWithFormat:@"订购状态："];
    if ([[self.dataDictionary valueForKey:@"hoststate"] isEqualToString:@"0"]) {
        [str1 appendString:@"已订购"];
    }else{
        [str1 appendString:@"未订购"];
    }
    NSMutableString *str2 = [NSMutableString stringWithFormat:@"用户状态："];
    NSMutableString *str3 = [NSMutableString stringWithFormat:@"呼叫号码："];
//    NSString *hostNumber = [[self.dataDictionary valueForKey:@"data"] valueForKey:@"hostNumber"];
//    if (hostNumber.length > 4) {
//        hostNumber = [hostNumber substringWithRange:NSMakeRange(0, 4)];
//    }
    if ([pinfo.ishost isEqualToString:@"0"]) {
        [str2 appendString:@"主账号"];
//        [str3 appendFormat:@"%@",[[self.dataDictionary valueForKey:@"data"] valueForKey:@"hostNumber"]];
    }else{
        [str2 appendString:@"副账号"];
//        [str3 appendFormat:@"%@%@",hostNumber,[[self.dataDictionary valueForKey:@"ext"] valueForKey:@"extensionNumber"]];
    }
//    if ([[self.dataDictionary valueForKey:@"phonenumber"] isKindOfClass:[NSString class]]) {
//        [str3 appendFormat:@"%@",[self.dataDictionary valueForKey:@"phonenumber"]];
//    }
    if ([[pinfo.eboExt valueForKey:@"phonenumber"] isKindOfClass:[NSString class]]) {
        [str3 appendFormat:@"%@",[pinfo.eboExt valueForKey:@"phonenumber"]];
    }
    
    NSMutableString *str4 = [NSMutableString stringWithFormat:@"付款方式："];
    if ([[self.dataDictionary valueForKey:@"paystate"] isEqualToString:@"0"]) {
        [str4 appendString:@"个付"];
    }else{
        [str4 appendString:@"统付"];
    }
    
//    NSTimeInterval ti5 = [[[[self.dataDictionary valueForKey:@"data"] valueForKey:@"startDate"] valueForKey:@"time"] integerValue]/1000;
//    NSDate *date5 = [NSDate dateWithTimeIntervalSince1970:ti5];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSMutableString *str5 = [NSMutableString stringWithFormat:@"生效时间：%@",[self.dataDictionary valueForKey:@"startdate"]];
//    NSTimeInterval ti6 = [[[[self.dataDictionary valueForKey:@"data"] valueForKey:@"endDate"] valueForKey:@"time"] integerValue]/1000;
//    NSDate *date6 = [NSDate dateWithTimeIntervalSince1970:ti6];
    NSMutableString *str6 = [NSMutableString stringWithFormat:@"失效时间：%@",[self.dataDictionary valueForKey:@"enddate"]];
//    self.dataDictionary = [NSMutableDictionary dictionaryWithDictionary:rootDic];
//    //tableview显示相关
//    NSMutableString *str1 = [NSMutableString stringWithFormat:@"订购状态："];
//    if ([[[self.dataDictionary valueForKey:@"data"] valueForKey:@"hostState"] isEqualToString:@"0"]) {
//        [str1 appendString:@"已订购"];
//    }else{
//        [str1 appendString:@"未订购"];
//    }
//    NSMutableString *str2 = [NSMutableString stringWithFormat:@"用户状态："];
//    NSMutableString *str3 = [NSMutableString stringWithFormat:@"呼叫号码："];
//    NSString *hostNumber = [[self.dataDictionary valueForKey:@"data"] valueForKey:@"hostNumber"];
//    if (hostNumber.length > 4) {
//        hostNumber = [hostNumber substringWithRange:NSMakeRange(0, 4)];
//    }
//    if ([[self.dataDictionary valueForKey:@"isHost"] isEqualToString:@"0"]) {
//        [str2 appendString:@"主账号"];
//        [str3 appendFormat:@"%@",[[self.dataDictionary valueForKey:@"data"] valueForKey:@"hostNumber"]];
//    }else{
//        [str2 appendString:@"副账号"];
//        [str3 appendFormat:@"%@%@",hostNumber,[[self.dataDictionary valueForKey:@"ext"] valueForKey:@"extensionNumber"]];
//    }
//    
//    NSMutableString *str4 = [NSMutableString stringWithFormat:@"付款方式："];
//    if ([[[self.dataDictionary valueForKey:@"data"] valueForKey:@"hostState"] isEqualToString:@"0"]) {
//        [str4 appendString:@"个付"];
//    }else{
//        [str4 appendString:@"统付"];
//    }
//    
//    NSTimeInterval ti5 = [[[[self.dataDictionary valueForKey:@"data"] valueForKey:@"startDate"] valueForKey:@"time"] integerValue]/1000;
//    NSDate *date5 = [NSDate dateWithTimeIntervalSince1970:ti5];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSMutableString *str5 = [NSMutableString stringWithFormat:@"生效时间：%@",[formatter stringFromDate:date5]];
//    NSTimeInterval ti6 = [[[[self.dataDictionary valueForKey:@"data"] valueForKey:@"endDate"] valueForKey:@"time"] integerValue]/1000;
//    NSDate *date6 = [NSDate dateWithTimeIntervalSince1970:ti6];
//    NSMutableString *str6 = [NSMutableString stringWithFormat:@"失效时间：%@",[formatter stringFromDate:date6]];
    self.displayArray = [NSMutableArray arrayWithObjects:@"",str1,str2,str3,str4,str5,str6,@"",nil];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.displayArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 116.0f;
    }else{
        return 44.0f;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        kqPIFTableViewCell *cell = (kqPIFTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"kqPIFTableViewCell" owner:self options:nil] objectAtIndex:0];
        kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
        if ([[pinfo.userInfomation valueForKey:@"usericon"] isKindOfClass:[NSNull class]]) {
            [cell.headerImageView setImage:[UIImage imageNamed:@"zhanghuxinxi"]];
        }else{
            NSString *urlString = [NSString stringWithFormat:@"%@",[pinfo.userInfomation valueForKey:@"usericon"]];
            //        [self.headerImageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"zhanghuxinxi"]];
            [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"zhanghuxinxi"]];
        }
        if ([[pinfo.userInfomation valueForKey:@"username"] isKindOfClass:[NSNull class]]) {
            cell.nameLabel.hidden = YES;
        }else{
            cell.nameLabel.text = [pinfo.userInfomation valueForKey:@"username"];
        }
        if (!([[pinfo.userInfomation valueForKey:@"company"] isKindOfClass:[NSNull class]])) {
            cell.companyLabel.text = [pinfo.userInfomation valueForKey:@"company"];
        }else{
            cell.companyLabel.hidden = YES;
        }
        if (!([[pinfo.userInfomation valueForKey:@"userposition"] isKindOfClass:[NSNull class]])) {
            cell.postionLabel.text = [pinfo.userInfomation valueForKey:@"userposition"];
        }else{
            cell.postionLabel.hidden = YES;
        }
        return cell;
    }else {
        kqLeftTableViewCell *cell = (kqLeftTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"kqLeftTableViewCell" owner:self options:nil] objectAtIndex:0];
        if (indexPath.row == 7){
            cell.preLabel.text = [NSString stringWithFormat:@"设置"];
            cell.label.hidden = YES;
            cell.arrowImageView.hidden = NO;
            cell.backgroundColor = RGB(250, 250, 250, 1);
        }else{
            NSString *dispString = [self.displayArray objectAtIndex:indexPath.row];
            NSArray *disArr = [dispString componentsSeparatedByString:@"："];
            cell.preLabel.text = [NSString stringWithFormat:@"%@：",[disArr objectAtIndex:0]];
            cell.label.text = [disArr objectAtIndex:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

-(void)didModifedPersonalInfomation
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *arr = [NSArray arrayWithObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:NO];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 7) {
        self.hidesBottomBarWhenPushed = YES;
        kqSettingViewController *svc = [[kqSettingViewController alloc] initWithNibName:@"kqSettingViewController" bundle:nil];
        [self.navigationController pushViewController:svc animated:YES];
    }else if(indexPath.row == 0){
        self.hidesBottomBarWhenPushed = YES;
        kqEditPersonalCenterViewController *epcvc = [[kqEditPersonalCenterViewController alloc] initWithNibName:@"kqEditPersonalCenterViewController" bundle:nil];
        epcvc.delegate = self;
        [self.navigationController pushViewController:epcvc animated:YES];
    }
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
