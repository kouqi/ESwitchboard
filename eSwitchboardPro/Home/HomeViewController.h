//
//  HomeViewController.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/6/11.
//  Copyright (c) 2015年 海峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UIButton *leftBackButton,*rightButton;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;
@end
