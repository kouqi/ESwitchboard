//
//  kqMailListViewController.m
//  eSwitchboardPro
//
//  Created by 海峰 on 15/6/12.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import "kqMailListViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ChineseToPinyin.h"
#import "DialViewController.h"
#import "kqContactDetailViewController.h"
#import "kqDialExtensionTableViewCell.h"
#import "kqDialChatViewController.h"
@interface kqMailListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ABNewPersonViewControllerDelegate,kqChangeMailListDelegate>
@property (weak, nonatomic) IBOutlet UIView *topSearchView;
@property (weak, nonatomic) IBOutlet UIImageView *topBackgroundView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) UIButton *topDelButton;
@property (strong,nonatomic) NSMutableArray *dataArray,*resultArray,*suoyingArray,*enterpriseArray;
@property (strong, nonatomic) UITableView *mailListTableView,*tableView;
@property (strong, nonatomic) UINavigationController *pnavi;
@end

@implementation kqMailListViewController

-(void)didChangedTheMailList
{
    [self initMailListArray];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    [self initTopBar];
    
    UIImage *image = [UIImage imageNamed:@"search.png"];
    UIEdgeInsets edgeInsets = {0,40,0,20};
    image = [image resizableImageWithCapInsets:edgeInsets];
    self.topBackgroundView.image = image;
    self.searchTextField.delegate = self;
    UIScreen *ms = [UIScreen mainScreen];
    self.topDelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.topDelButton.frame = CGRectMake(ms.bounds.size.width - 40, 10, 20, 20);
    [self.topDelButton setBackgroundImage:[UIImage imageNamed:@"del.png"] forState:UIControlStateNormal];
    [self.topDelButton addTarget:self action:@selector(tapDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.topSearchView addSubview:self.topDelButton];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resResponder)];
//    [self.view addGestureRecognizer:tap];
    
    self.mailListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topSearchView.frame.origin.y + self.topSearchView.frame.size.height, ms.bounds.size.width, ms.bounds.size.height - (self.topSearchView.frame.size.height + self.topSearchView.frame.origin.y + 44.0f)) style:UITableViewStylePlain];
    self.mailListTableView.delegate = self;
    self.mailListTableView.dataSource = self;
    [self.view addSubview:self.mailListTableView];
    [self initMailListArray];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topSearchView.frame.origin.y + self.topSearchView.frame.size.height, ms.bounds.size.width, ms.bounds.size.height - (self.topSearchView.frame.size.height + self.topSearchView.frame.origin.y + 44.0f))];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    self.enterpriseArray = [NSMutableArray arrayWithArray:pinfo.extenseionArray];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


#pragma keyBoardNotification
-(void) keyboardWillShow:(NSNotification *)note
{
    UIScreen *ms = [UIScreen mainScreen];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.tableView.frame = CGRectMake(0, self.topSearchView.frame.origin.y + self.topSearchView.frame.size.height, ms.bounds.size.width, ms.bounds.size.height - (self.topSearchView.frame.size.height + self.topSearchView.frame.origin.y + 44.0f) - keyboardBounds.size.height);
    self.mailListTableView.frame = CGRectMake(0, self.topSearchView.frame.origin.y + self.topSearchView.frame.size.height, ms.bounds.size.width, ms.bounds.size.height - (self.topSearchView.frame.size.height + self.topSearchView.frame.origin.y + 44.0f) - keyboardBounds.size.height);
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    UIScreen *ms = [UIScreen mainScreen];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.tableView.frame = CGRectMake(0, self.topSearchView.frame.origin.y + self.topSearchView.frame.size.height, ms.bounds.size.width, ms.bounds.size.height - (self.topSearchView.frame.size.height + self.topSearchView.frame.origin.y + 44.0f));
    self.mailListTableView.frame = CGRectMake(0, self.topSearchView.frame.origin.y + self.topSearchView.frame.size.height, ms.bounds.size.width, ms.bounds.size.height - (self.topSearchView.frame.size.height + self.topSearchView.frame.origin.y + 44.0f));
    [UIView commitAnimations];
    [self.enterpriseArray removeAllObjects];
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    self.enterpriseArray = [NSMutableArray arrayWithArray:pinfo.extenseionArray];
    [self.tableView reloadData];
    [self initMailListArray];
}


-(void) initTopBar
{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_add_StoreOrGoods"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(tapRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rbbi;
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"个人通讯录",@"企业通讯录",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0.0, 0.0, 120.0, 30.0);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = segmentedControl;
//    [self.navigationController.inputView addSubview:segmentedControl];
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %li", (long)Index);
    switch (Index) {
        case 0:
        {
            self.tableView.hidden = YES;
            self.mailListTableView.hidden = NO;
        }
            break;
        case 1:
        {
            self.tableView.hidden = NO;
            self.mailListTableView.hidden = YES;
        }
            break;
        default:
            break;
    }
}
    
-(void) tapRightButton
{
    ABNewPersonViewController *abnewpVC = [[ABNewPersonViewController alloc] init];
    abnewpVC.newPersonViewDelegate = self;
    self.pnavi = [[UINavigationController alloc] initWithRootViewController:abnewpVC];
    [self presentViewController:self.pnavi animated:YES completion:^{
        
    }];
    
    
//    // Fetch the address book
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    // Search for the person named "Appleseed" in the address book
////    NSArray *people = (__bridge NSArray *)ABAddressBookCopyPeopleWithName(addressBook, CFSTR("宝贝公司"));
//    NSArray *people = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
//    // Display "Appleseed" information if found in the address book
//    if ((people != nil) && [people count]){
//        ABRecordRef person = (__bridge ABRecordRef)[people objectAtIndex:0];
//        
//        ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
////        picker.personViewDelegate = self;
//        picker.displayedPerson = person;
//        // Allow users to edit the person’s information
////        picker.allowsEditing = YES;
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:picker];
//        [self presentViewController:navi animated:YES completion:^{
//            
//        }];
//    }else{
//        // Show an alert if "Appleseed" is not in Contacts
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                       message:@"Could not find Appleseed in the Contacts application"
//                                                      delegate:nil 
//                                             cancelButtonTitle:@"Cancel" 
//                                             otherButtonTitles:nil];
//        [alert show];
//    }
//    CFRelease(addressBook);
}

-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    
    [self.pnavi dismissViewControllerAnimated:YES completion:^{
        if (person) {
            [self initMailListArray];
        }
    }];
}

-(void) tapDeleteButton
{
    self.searchTextField.text = nil;
    [self.searchTextField resignFirstResponder];
    [self getResultArrayWithArray:self.dataArray];
}

-(void) resResponder
{
    [self.searchTextField resignFirstResponder];
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
//        [mdic setValue:tmpFirstName forKey:@"FirstName"];
        ABRecordID recordId = ABRecordGetRecordID((__bridge ABRecordRef)(tmpPerson));
        [mdic setValue:[NSNumber numberWithInt:recordId] forKey:@"RecordID"];
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        //        NSLog(@"Last name:%@", tmpLastName);
//        [mdic setValue:tmpLastName forKey:@"LastName"];
        NSString *name;
        if (tmpFirstName && tmpLastName) {
            name = [NSString stringWithFormat:@"%@%@",tmpLastName,tmpFirstName];
        }else{
            if (tmpLastName) {
                name = [NSString stringWithFormat:@"%@",tmpLastName];
            }else if(tmpFirstName){
                name = [NSString stringWithFormat:@"%@",tmpFirstName];
            }else{
                name = nil;
            }
        }
        [mdic setValue:name forKey:@"LastName"];
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
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    if (pinfo.extenseionArray.count > 0) {
        for (NSMutableDictionary *mdic in pinfo.extenseionArray) {
            NSString *bf = [mdic valueForKey:@"phoneNumber"];
            for (NSMutableDictionary *mdicl in dataArray) {
                NSArray *phoneArray = [mdicl valueForKey:@"Phones"];
                BOOL isBreak = NO;
                for (NSString *pj in phoneArray) {
                    NSString *pp = [pj stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    if ([bf isEqualToString:pp]) {
                        NSString *lastName = [mdicl valueForKey:@"LastName"];
                        if (lastName) {
                           [mdic setValue:lastName forKey:@"disPlayName"];
                        }else{
                           [mdic setValue:@"无姓名" forKey:@"disPlayName"];
                        }
                        isBreak = YES;
                        break;
                    }
                }
                if (isBreak) {
                    break;
                }
            }
        }
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
//TODO:textfield代理
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *textPstr;
    if (![string isEqualToString:@""]) {
        if (range.location == 0 && range.length == 0) {
            textPstr = [ChineseToPinyin pinyinFromChiniseString:string];
        }else{
            textPstr = [ChineseToPinyin pinyinFromChiniseString:[NSString stringWithFormat:@"%@%@",self.searchTextField.text,string]];
        }
    }else{
        if (range.location == 0 && range.length == 1) {
            [self getResultArrayWithArray:self.dataArray];
            return YES;
        }else{
            textPstr = [ChineseToPinyin pinyinFromChiniseString:[self.searchTextField.text substringWithRange:NSMakeRange(0, self.searchTextField.text.length - 1)]];
        }
    }
    if (textPstr) {
        NSMutableArray *resArr = [NSMutableArray array];
        if (self.tableView.hidden) {
            for (NSDictionary *dic in self.dataArray) {
                NSString *lnamePstr = [ChineseToPinyin pinyinFromChiniseString:[dic valueForKey:@"LastName"]];
                if ([lnamePstr containsString:textPstr]) {
                    [resArr addObject:dic];
                }
            }
            [self getResultArrayWithArray:resArr];
        }else{
            [self seacherEnArrayWithString:textPstr];
        }
    }
    return YES;
}

-(void) seacherEnArrayWithString:(NSString *) textPstr
{
    [self.enterpriseArray removeAllObjects];
    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    for (NSDictionary *dic in pinfo.extenseionArray) {
        NSString *displayName = [dic valueForKey:@"disPlayName"];
        if ([dic valueForKey:@"username"] && [[dic valueForKey:@"username"] isKindOfClass:[NSString class]]) {
            if (displayName) {
                if ([[ChineseToPinyin pinyinFromChiniseString:displayName] containsString:textPstr] || [[ChineseToPinyin pinyinFromChiniseString:[dic valueForKey:@"username"]] containsString:textPstr] || [[dic valueForKey:@"extnumber"] containsString:textPstr] || [[dic valueForKey:@"phonenumber"] containsString:textPstr]) {
                    [self.enterpriseArray addObject:dic];
                }
            }else{
                if ([[ChineseToPinyin pinyinFromChiniseString:[dic valueForKey:@"username"]] containsString:textPstr] || [[dic valueForKey:@"extnumber"] containsString:textPstr] || [[dic valueForKey:@"phonenumber"] containsString:textPstr]) {
                    [self.enterpriseArray addObject:dic];
                }
            }
            
        }else{
            if(displayName){
                if ([[ChineseToPinyin pinyinFromChiniseString:displayName] containsString:textPstr] || [[dic valueForKey:@"extnumber"] containsString:textPstr] || [[dic valueForKey:@"phonenumber"] containsString:textPstr]) {
                    [self.enterpriseArray addObject:dic];
                }
            }else{
                if ([[dic valueForKey:@"extnumber"] containsString:textPstr] || [[dic valueForKey:@"phonenumber"] containsString:textPstr]) {
                    [self.enterpriseArray addObject:dic];
                }
            }
        }
    }
    [self.tableView reloadData];
}

//TODO:tableview代理
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.mailListTableView]) {
        return self.suoyingArray;
    }else{
        return nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.tableView]) {
        return 1;
    }
    return self.resultArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.mailListTableView isEqual:tableView]) {
        NSArray *arr = [[self.resultArray objectAtIndex:section] valueForKey:@"dataArray"];
        return arr.count;
    }
//    kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
    return self.enterpriseArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView isEqual:tableView]) {
        return 65.0f;
    }
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.tableView isEqual:tableView]) {
        return 0;
    }
    return 20.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.tableView isEqual:tableView]) {
        return nil;
    }
    NSDictionary *dic = [self.resultArray objectAtIndex:section];
    return [dic valueForKey:@"headerStr"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView isEqual:tableView]) {
        kqDialExtensionTableViewCell *cell = (kqDialExtensionTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"kqDialExtensionTableViewCell" owner:self options:nil] objectAtIndex:0];
//        kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
        NSDictionary *dic = [self.enterpriseArray objectAtIndex:indexPath.row];
        if ([dic valueForKey:@"username"] && [[dic valueForKey:@"username"] isKindOfClass:[NSString class]]) {
            cell.extLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"username"]];
        }else{
            cell.extLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"extnumber"]];
        }
        NSString *displayName = [dic valueForKey:@"disPlayName"];
        if (displayName) {
            cell.phoneLabel.text = displayName;
        }else{
            cell.phoneLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"extnumber"]];
        }
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSDictionary *dic = [[[self.resultArray objectAtIndex:indexPath.section] valueForKey:@"dataArray"] objectAtIndex:indexPath.row];
    NSString *lastName = [dic valueForKey:@"LastName"];
    if (lastName) {
        cell.textLabel.text = lastName;
    }else{
        cell.textLabel.text = @"无姓名";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.searchTextField resignFirstResponder];
    if ([self.tableView isEqual:tableView]) {
        kqPersonalInfomation *pinfo = [kqPersonalInfomation sharedPersonalInfomation];
        NSDictionary *dic = [self.enterpriseArray objectAtIndex:indexPath.row];
        if ([[dic valueForKey:@"extnumber"] isEqualToString:pinfo.callNumber]) {
//            [kqAllTools showAlertViewWithTitle:@"提示" andMessage:@"不能拨自己的sip电话"];
            [kqAllTools showTipTextOnWindow:@"不能拨自己的sip电话！"];
        }else{
            kqDialChatViewController *dcvc = [[kqDialChatViewController alloc] initWithNibName:@"kqDialChatViewController" bundle:nil];
            dcvc.phoneNUmber = [NSString stringWithFormat:@"%@",[dic valueForKey:@"extnumber"]];
            if ([dic valueForKey:@"username"] && [[dic valueForKey:@"username"] isKindOfClass:[NSString class]]) {
                dcvc.displayNumber = [NSString stringWithFormat:@"%@",[dic valueForKey:@"username"]];
            }else{
                dcvc.displayNumber = [NSString stringWithFormat:@"%@",[dic valueForKey:@"extnumber"]];
            }
            
            [self presentViewController:dcvc animated:YES completion:^{
            }];
        }
        return;
    }
    
    NSDictionary *dic = [[[self.resultArray objectAtIndex:indexPath.section] valueForKey:@"dataArray"] objectAtIndex:indexPath.row];
    kqContactDetailViewController *cdVC = [[kqContactDetailViewController alloc] initWithNibName:@"kqContactDetailViewController" bundle:nil];
    cdVC.phoneDictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    self.hidesBottomBarWhenPushed = YES;
    cdVC.delegate = self;
    [self.navigationController pushViewController:cdVC animated:YES];
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
