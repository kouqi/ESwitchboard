//
//  kqContactDetailViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/9/20.
//  Copyright © 2015年 海峰. All rights reserved.
//

#import "kqContactDetailViewController.h"
#import "kqContactPhoneTableViewCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "kqDialChatViewController.h"
@interface kqContactDetailViewController ()<UITableViewDataSource,UITableViewDelegate,kqContactCellTapCallButtonDelegate,UIActionSheetDelegate,ABNewPersonViewControllerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UINavigationController *pnavi;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UITableView *phoneTableView;
@property (strong, nonatomic) NSMutableArray *phoneArray;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation kqContactDetailViewController

-(void) initTopBar
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(tapRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = rbbi;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setTitle:@"更多" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(tapMoreButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lbbi = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = lbbi;
}

-(void) tapRightButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) tapMoreButton
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除联系人" otherButtonTitles:@"编辑联系人", nil];
    [as showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    ABAddressBookRef ab = ABAddressBookCreate();
    ABRecordID recordId= [[self.phoneDictionary valueForKey:@"RecordID"] intValue];
    ABRecordRef record = ABAddressBookGetPersonWithRecordID(ab, recordId);
    if (buttonIndex == 1) {
        ABNewPersonViewController *abnewpVC = [[ABNewPersonViewController alloc] init];
        abnewpVC.displayedPerson = record;
        abnewpVC.newPersonViewDelegate = self;
        abnewpVC.title = @"编辑联系人";
        self.pnavi = [[UINavigationController alloc] initWithRootViewController:abnewpVC];
        [self presentViewController:self.pnavi animated:YES completion:^{
            
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否继续删除联系人" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    ABAddressBookRef ab = ABAddressBookCreate();
    ABRecordID recordId= [[self.phoneDictionary valueForKey:@"RecordID"] intValue];
    ABRecordRef record = ABAddressBookGetPersonWithRecordID(ab, recordId);
    CFErrorRef err;
    BOOL success =ABAddressBookRemoveRecord(ab, record, &err);//删除
    if (success) {
        ABAddressBookSave(ab, &err);
//        [kqAllTools showAlertViewWithTitle:@"提示" andMessage:@"删除联系人成功！"];
        [kqAllTools showTipTextOnWindow:@"删除联系人成功！"];
        [self.delegate didChangedTheMailList];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    [self.pnavi dismissViewControllerAnimated:YES completion:^{
        if (person) {
            [self.delegate didChangedTheMailList];
            NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
            
            //获取的联系人单一属性:First name
            
            NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            //        NSLog(@"First name:%@", tmpFirstName);
            [mdic setValue:tmpFirstName forKey:@"FirstName"];
            ABRecordID recordId = ABRecordGetRecordID(person);
            [mdic setValue:[NSNumber numberWithInt:recordId] forKey:@"RecordID"];
            //获取的联系人单一属性:Last name
            NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
            //        NSLog(@"Last name:%@", tmpLastName);
            [mdic setValue:tmpLastName forKey:@"LastName"];
            //获取的联系人单一属性:Nickname
            NSString* tmpNickname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
            //        NSLog(@"Nickname:%@", tmpNickname);
            [mdic setValue:tmpNickname forKey:@"Nickname"];
            //获取的联系人单一属性:Company name
            NSString* tmpCompanyname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
            //        NSLog(@"Company name:%@", tmpCompanyname);
            [mdic setValue:tmpCompanyname forKey:@"Company"];
            //获取的联系人单一属性:Job Title
            NSString* tmpJobTitle= (__bridge NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
            //        NSLog(@"Job Title:%@", tmpJobTitle);
            [mdic setValue:tmpJobTitle forKey:@"Job"];
            //获取的联系人单一属性:Department name
            NSString* tmpDepartmentName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
            //        NSLog(@"Department name:%@", tmpDepartmentName);
            [mdic setValue:tmpDepartmentName forKey:@"Department"];
            //获取的联系人单一属性:Email(s)
            ABMultiValueRef tmpEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
            NSMutableArray *tmpEmailArray = [NSMutableArray array];
            for(NSInteger j = 0; j < ABMultiValueGetCount(tmpEmails); j++){
                NSString* tmpEmailIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpEmails, j);
                //            NSLog(@"Emails%ld:%@", (long)j, tmpEmailIndex);
                [tmpEmailArray addObject:tmpEmailIndex];
            }
            [mdic setValue:tmpEmailArray forKey:@"Emails"];
            CFRelease(tmpEmails);
            //获取的联系人单一属性:Birthday
            NSDate* tmpBirthday = (__bridge NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
            //        NSLog(@"Birthday:%@", tmpBirthday);
            [mdic setValue:tmpBirthday forKey:@"Birthday"];
            //获取的联系人单一属性:Note
            NSString* tmpNote = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNoteProperty);
            //        NSLog(@"Note:%@", tmpNote);
            [mdic setValue:tmpNote forKey:@"Note"];
            //获取的联系人单一属性:Generic phone number
            ABMultiValueRef tmpPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            NSMutableArray *tmpPhoneArray = [NSMutableArray array];
            for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++){
                NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
                //            NSLog(@"tmpPhoneIndex%ld:%@", (long)j, tmpPhoneIndex);
                [tmpPhoneArray addObject:tmpPhoneIndex];
            }
            [mdic setValue:tmpPhoneArray forKey:@"Phones"];
            self.phoneDictionary = [NSMutableDictionary dictionaryWithDictionary:mdic];
            [self initView];
        }
    }];
}

-(void) initView
{
    NSArray *arr = [self.phoneDictionary valueForKey:@"Phones"];
    if (self.phoneArray) {
        [self.phoneArray removeAllObjects];
        [self.phoneArray addObjectsFromArray:arr];
    }else{
        self.phoneArray = [NSMutableArray arrayWithArray:arr];
    }
    [self.phoneTableView reloadData];
    NSString *lastName = [self.phoneDictionary valueForKey:@"LastName"];
    if (lastName) {
        self.nameLabel.text = lastName;
    }else{
        self.nameLabel.text = @"无姓名";
//        NSArray *arr = [self.phoneDictionary valueForKey:@"Phones"];
//        if (arr.count > 0) {
//            NSString *display = [[self.phoneDictionary valueForKey:@"Phones"] objectAtIndex:0];
//            self.nameLabel.text = display;
//        }else{
//            self.nameLabel.text = [self.phoneDictionary valueForKey:@"Company"];
//        }
    }
    NSMutableString *companyString = [NSMutableString stringWithFormat:@"%@",[self.phoneDictionary valueForKey:@"Company"]];
    if (![companyString isEqualToString:@"(null)"]) {
        NSString *jobString = [self.phoneDictionary valueForKey:@"Job"];
        if (jobString) {
            [companyString appendFormat:@" %@",jobString];
        }
        self.companyLabel.text = companyString;
    }else{
        NSMutableString *jobString = [self.phoneDictionary valueForKey:@"Job"];
        if (jobString) {
            self.companyLabel.text = jobString;
        }else{
            self.companyLabel.hidden = YES;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self initTopBar];
    self.phoneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initView];
        // Do any additional setup after loading the view from its nib.
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
    return self.phoneArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    kqContactPhoneTableViewCell *cell = (kqContactPhoneTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"kqContactPhoneTableViewCell" owner:self options:nil] objectAtIndex:0];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.phoneNumberLabel.text = [self.phoneArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)didTapCallButtonWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"=======%ld",(long)indexPath.row);
    kqDialChatViewController *dcvc = [[kqDialChatViewController alloc] initWithNibName:@"kqDialChatViewController" bundle:nil];
    dcvc.phoneNUmber = [self.phoneArray objectAtIndex:indexPath.row];
    dcvc.displayNumber = [self.phoneArray objectAtIndex:indexPath.row];
    [self presentViewController:dcvc animated:YES completion:^{
    }];
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
