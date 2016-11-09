//
//  kqSelectContactButtonViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/8/23.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqSelectContactButtonViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ChineseToPinyin.h"
@interface kqSelectContactButtonViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UIButton *topDelButton;
@property (strong,nonatomic) NSMutableArray *dataArray,*resultArray,*suoyingArray;
@property (strong, nonatomic) UITableView *mailListTableView;

@end

@implementation kqSelectContactButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查找联系人";
    [self initTopBar];
    UIScreen *ms = [UIScreen mainScreen];
    self.mailListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ms.bounds.size.width, ms.bounds.size.height - 64) style:UITableViewStylePlain];
    self.mailListTableView.delegate = self;
    self.mailListTableView.dataSource = self;
    [self.view addSubview:self.mailListTableView];
    [self initMailListArray];
    
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

-(void) initMailListArray
{
    //取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        tmpAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        tmpAddressBook = ABAddressBookCreate();
    }
    //取得本地所有联系人记录
    if (tmpAddressBook == nil) {
        return ;
    };
    NSMutableArray *dataArray = [NSMutableArray array];
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    for(id tmpPerson in tmpPeoples){
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        //获取的联系人单一属性:First name
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        //        NSLog(@"First name:%@", tmpFirstName);
        [mdic setValue:tmpFirstName forKey:@"FirstName"];
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        //        NSLog(@"Last name:%@", tmpLastName);
        [mdic setValue:tmpLastName forKey:@"LastName"];
        //获取的联系人单一属性:Nickname
        NSString* tmpNickname = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonNicknameProperty);
        //        NSLog(@"Nickname:%@", tmpNickname);
        [mdic setValue:tmpNickname forKey:@"Nickname"];
        //获取的联系人单一属性:Company name
        NSString* tmpCompanyname = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonOrganizationProperty);
        //        NSLog(@"Company name:%@", tmpCompanyname);
        [mdic setValue:tmpCompanyname forKey:@"Company"];
        //获取的联系人单一属性:Job Title
        NSString* tmpJobTitle= (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonJobTitleProperty);
        //        NSLog(@"Job Title:%@", tmpJobTitle);
        [mdic setValue:tmpJobTitle forKey:@"Job"];
        //获取的联系人单一属性:Department name
        NSString* tmpDepartmentName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonDepartmentProperty);
        //        NSLog(@"Department name:%@", tmpDepartmentName);
        [mdic setValue:tmpDepartmentName forKey:@"Department"];
        //获取的联系人单一属性:Email(s)
        ABMultiValueRef tmpEmails = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonEmailProperty);
        NSMutableArray *tmpEmailArray = [NSMutableArray array];
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpEmails); j++){
            NSString* tmpEmailIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpEmails, j);
            //            NSLog(@"Emails%ld:%@", (long)j, tmpEmailIndex);
            [tmpEmailArray addObject:tmpEmailIndex];
        }
        [mdic setValue:tmpEmailArray forKey:@"Emails"];
        CFRelease(tmpEmails);
        //获取的联系人单一属性:Birthday
        NSDate* tmpBirthday = (__bridge NSDate*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonBirthdayProperty);
        //        NSLog(@"Birthday:%@", tmpBirthday);
        [mdic setValue:tmpBirthday forKey:@"Birthday"];
        //获取的联系人单一属性:Note
        NSString* tmpNote = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonNoteProperty);
        //        NSLog(@"Note:%@", tmpNote);
        [mdic setValue:tmpNote forKey:@"Note"];
        //获取的联系人单一属性:Generic phone number
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        NSMutableArray *tmpPhoneArray = [NSMutableArray array];
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++){
            NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
            //            NSLog(@"tmpPhoneIndex%ld:%@", (long)j, tmpPhoneIndex);
            [tmpPhoneArray addObject:tmpPhoneIndex];
        }
        [mdic setValue:tmpPhoneArray forKey:@"Phones"];
        //        BOOL flag = NO;
        //        for (NSDictionary *dic in self.storeContactArray) {
        //            NSString *phone = [dic valueForKey:@"contactPhone"];
        //            for (NSString *tmpPhone in tmpPhoneArray) {
        //                if ([tmpPhone isEqualToString:phone]) {
        //                    flag = YES;
        //                    break;
        //                }
        //            }
        //            if (flag) {
        //                break;
        //            }
        //        }
        //        [mdic setValue:[NSNumber numberWithBool:flag] forKey:@"flag"];
        CFRelease(tmpPhones);
        [dataArray addObject:mdic];
    }
    //释放内存
    CFRelease(tmpAddressBook);
    if (self.dataArray) {
        [self.dataArray removeAllObjects];
    }else{
        self.dataArray = [NSMutableArray array];
    }
    NSMutableArray *firstLayerArray = [NSMutableArray array];
    [firstLayerArray addObjectsFromArray:[dataArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *dic1 = (NSDictionary *) obj1;
        NSDictionary *dic2 = (NSDictionary *) obj2;
        NSString *lname1 = [dic1 valueForKey:@"LastName"];
        NSString *lname2 = [dic2 valueForKey:@"LastName"];
        NSComparisonResult result = [[ChineseToPinyin pinyinFromChiniseString:lname1] compare:[ChineseToPinyin pinyinFromChiniseString:lname2]];
        return result;
    }]];
    [self.dataArray addObjectsFromArray:firstLayerArray];
    [self getResultArrayWithArray:firstLayerArray];
}

-(void) getResultArrayWithArray:(NSArray *) arr
{
    if (self.resultArray) {
        [self.resultArray removeAllObjects];
    }else{
        self.resultArray = [NSMutableArray array];
    }
    NSMutableSet *set = [NSMutableSet set];
    for (NSDictionary *dic in arr) {
        NSString *lname = [dic valueForKey:@"LastName"];
        if (lname) {
            NSString *sstr = [[ChineseToPinyin pinyinFromChiniseString:lname] substringWithRange:NSMakeRange(0, 1)];
            [set addObject:sstr];
        }
    }
    [set addObject:@"*"];
    NSMutableArray *suoyingArr = [NSMutableArray array];
    NSMutableArray *thirdArray = [NSMutableArray array];
    for (NSString *sstr in set) {
        [suoyingArr addObject:sstr];
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        NSMutableArray *secArray = [NSMutableArray array];
        [mdic setValue:sstr forKey:@"headerStr"];
        if ([sstr isEqualToString:@"*"]) {
            for (NSDictionary *dic in arr) {
                NSString *lname = [dic valueForKey:@"LastName"];
                if (!lname) {
                    [secArray addObject:dic];
                }
            }
        }else{
            for (NSDictionary *dic in arr) {
                NSString *lname = [dic valueForKey:@"LastName"];
                if (lname) {
                    NSString *sstr2 = [[ChineseToPinyin pinyinFromChiniseString:lname] substringWithRange:NSMakeRange(0, 1)];
                    if ([sstr2 isEqualToString:sstr]) {
                        [secArray addObject:dic];
                    }
                }
            }
        }
        [mdic setValue:secArray forKey:@"dataArray"];
        [thirdArray addObject:mdic];
    }
    if (self.suoyingArray) {
        [self.suoyingArray removeAllObjects];
    }else{
        self.suoyingArray = [NSMutableArray array];
    }
    [self.suoyingArray addObjectsFromArray:[suoyingArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *lname1 = (NSString *) obj1;
        NSString *lname2 = (NSString *) obj2;
        NSComparisonResult result = [[ChineseToPinyin pinyinFromChiniseString:lname1] compare:[ChineseToPinyin pinyinFromChiniseString:lname2]];
        return result;
    }]];
    
    [self.resultArray addObjectsFromArray:[thirdArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *dic1 = (NSDictionary *) obj1;
        NSDictionary *dic2 = (NSDictionary *) obj2;
        NSString *lname1 = [dic1 valueForKey:@"headerStr"];
        NSString *lname2 = [dic2 valueForKey:@"headerStr"];
        NSComparisonResult result = [[ChineseToPinyin pinyinFromChiniseString:lname1] compare:[ChineseToPinyin pinyinFromChiniseString:lname2]];
        return result;
    }]];
    [self.mailListTableView reloadData];
}

//TODO:tableview代理
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.suoyingArray;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.resultArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [[self.resultArray objectAtIndex:section] valueForKey:@"dataArray"];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = [self.resultArray objectAtIndex:section];
    return [dic valueForKey:@"headerStr"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSDictionary *dic = [[[self.resultArray objectAtIndex:indexPath.section] valueForKey:@"dataArray"] objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic valueForKey:@"LastName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = [[[self.resultArray objectAtIndex:indexPath.section] valueForKey:@"dataArray"] objectAtIndex:indexPath.row];
    NSArray *phoneArray = [dic valueForKey:@"Phones"];
    [self.delegate didSelectContactWithPhoneNumber:[phoneArray objectAtIndex:0]];
    [self.navigationController popViewControllerAnimated:YES];
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
